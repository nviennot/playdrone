#Script to facilitate manually verifying similar apps produced by the crawler. Logs results to json file
#Uses apk_tester in the vendor/apk2gold/ directory to compare bytecode methods
#See https://github.com/luchasei/apk_tester for source

require 'json'

PLAY_PREFIX = "https://play.google.com/store/apps/details?id=" 
GIT_REPOS_BASE_PATH = ""
INPUT_SIMILAR_APPS_FILE = ""
LOG_FILE = "similarityResults.json"


def write_log (log, log_name)
	File.open(log_name,"w") do |f|
	  f.write(JSON.pretty_generate(log))
	end
end

def log_statistics (log)
	code_false_positive = 0
	code_true_positive = 0
	code_false_negative = 0
	code_true_negative = 0
	res_false_positive = 0
	res_true_positive = 0
	null_count = 0

	log.each { |pair, results|
		if results["verified_is_similar"] == nil
			null_count += 1
		else	
			if (results['code_similarity_score'] > 0.8) && results["verified_is_similar"]
				code_true_positive += 1
				res_true_positive += 1
			elsif (results['code_similarity_score'] < 0.8) && results["verified_is_similar"]
				code_false_negative += 1
				res_true_positive += 1
			elsif (results['code_similarity_score'] > 0.8) && !results["verified_is_similar"]
				code_false_positive += 1
				res_false_positive += 1
			elsif (results['code_similarity_score'] < 0.8) && !results["verified_is_similar"]
				code_true_negative += 1
				res_false_positive += 1
			else
				puts "error for " + pair 
			end
		end		
	}

	total_adj = log.count - null_count

	puts "total apps test = " + log.count.to_s
	puts "total app that count not be verified = " + null_count.to_s
	puts "total apps adjusted = " + total_adj.to_s

	puts "code_true_positive = " + code_true_positive.to_s + " % = " + (100 * code_true_positive.to_f/total_adj).to_s
	puts "code_false_positive = " + code_false_positive.to_s + " % = " + (100 * code_false_positive.to_f/total_adj).to_s
	puts "code_true_negative = " + code_true_negative.to_s + " % = " + (100 * code_true_negative.to_f/total_adj).to_s
	puts "code_false_negative = " + code_false_negative.to_s + " % = " + (100 * code_false_negative.to_f/total_adj).to_s
	puts ""
	puts "res_true_positive = " + res_true_positive.to_s + " % = " + (100 * res_true_positive.to_f/total_adj).to_s
	puts "res_false_positive = " + res_false_positive.to_s + " % = " + (100 * res_false_positive.to_f/total_adj).to_s
end

def log_result(log_name, pair, res, looksSame, codeSame)
	log = JSON.parse( IO.read(log_name) )
	log[pair[0] + " " + pair[1]] = { 
		"original_app" => pair[0],
		"original_app_features" => res[1],
		"duplicate_app" =>  pair[1],
		"duplicate_app_features" => res[2],
		"code_similarity_score" => res[0],
		"verified_is_similar" => looksSame,
		"verified_code_same" => codeSame
	}
	write_log(log, log_name)
	puts "logged  to " + log_name + "\n\t" + pair[0] + " = " + res[1].to_s + "\n\t" + pair[1] + " = " + res[2].to_s + "\n\t" + "similarity score = " + res[0].to_s + "\n\t" + "verified looks same = " + looksSame.to_s + "\n\tverfied code same = " + codeSame.to_s
	log_statistics(log)
end

def rm_cloned_dir (cloned_dir_name)
	rm_output = `rm -rf #{cloned_dir_name}`	
	rm_result=$?.success?
	rm_result
end

def unzip_apk (apk_path)
	cert_output = `unzip -l #{apk_path}`
	cert_result=$?.success?
	cert_result
end

def apk_test (apk_path1, apk_path2)
	puts "java -jar apk_tester.jar -i #{apk_path1} -v #{apk_path2}"
	apk_test_output = `java -jar apk_tester.jar -i #{apk_path1} -v #{apk_path2}`
	res = apk_test_output.strip.split(/\s+/)
	ret = false
	if res.length == 3
		puts "#{res[0]} #{res[1]} #{res[2]}"
		ret = [res[0].to_f, res[1].to_i, res[2].to_i] 
	else
		puts apk_test_output
		ret = nil		
	end
	ret
end

def clone_dir (git_file_path)
	puts "cloning #{git_file_path}"
	clone_output = `git clone -b apk #{git_file_path}`
	result=$?.success?
	if !result
		puts clone_output
	end
	result
end

def directory_exists?(directory)
	File.directory?(directory)
end

def get_apk_dir (apk_id)
	repo_dir = apk_id.gsub('.','/')
	apk_dir = repo_dir.split('/')[-1]
end

def modify_path (apk_path)
	output = `mv #{apk_path} #{apk_path.to_s + '1'} `
	apk_path.to_s + '1'
end

def get_apk_by_id(apk_id, modify)
	repo_dir = apk_id.gsub('.','/')
	apk_dir = repo_dir.split('/')[-1]
	result = false

	if !directory_exists?(apk_dir)
		full_repo_path = GIT_REPOS_BASE_PATH + repo_dir + '.git'
		result = clone_dir(full_repo_path)
	end

	if modify and result
		apk_dir = modify_path(apk_dir)
	end

	if result
		apk_path = Dir["#{apk_dir}/*apk"].first
	else 
		apk_path = nil
	end
	
	apk_path
end

def get_rand (arr)
	arr.each{ |app|
		if !app.start_with?("com")
			return app
		end
	}
	return nil
end

def get_rand_pair(apps)
	while true
		app_tuple = apps.choice
		while app_tuple[0].start_with?("com")
			app_tuple = apps.choice
		end
		
		if (app2 = get_rand(app_tuple[1])) == nil
			next
		else
			return [app_tuple[0], app2]
		end
	end
end	

def get_src_path (apk_path)
	str = apk_path.split("/")
	str[1].slice! ".apk"	
	str2 = str[1].split(".")
	path = ""
	
	for index in 0 .. (str2.length - 2)
		path = path + "/" + str2[index]
	end
	
	if directory_exists?("tmp/" + str[1] + "/smali" + path)
		return "tmp/" + str[1] + "/smali" + path
	else
		return "tmp/" + str[1] + "/smali"
	end
end

apps_arr = JSON.parse( IO.read(INPUT_SIMILAR_APPS_FILE) ).to_a

while true
	sameCode = false
	looksSimilar = false

	pair = get_rand_pair(apps_arr)

	apk1_path = get_apk_by_id(pair[0], true)

	if apk1_path == nil
		next
	end

	apk2_path = get_apk_by_id(pair[1], false)

	if apk2_path == nil
		rm_cloned_dir(get_apk_dir(pair[0]).to_s + "1")
		next
	end

	puts PLAY_PREFIX + pair[0].to_s
	puts PLAY_PREFIX + pair[1].to_s

	res = apk_test(apk1_path, apk2_path)


	while true
		puts 'press t/f if app is similar'
		puts 'press n if not available'
		puts 'press v to compare in vim'
		cmd = STDIN.gets.chomp

		if cmd == "t"
			looksSimilar = true
			break
		elsif cmd == "n"
			looksSimilar = nil
			break
		elsif cmd == "f"
			break
		elsif cmd == "v"
			puts "vim #{get_src_path(apk1_path)} -c \"vsplit #{get_src_path(apk2_path)}\" "
			system "vim #{get_src_path(apk1_path)} -c \"vsplit #{get_src_path(apk2_path)}\" "
		end
	end


	while true
		puts 'press t/f if code is same'
		puts 'press n if not available'
		puts 'press v to compare in vim'
		cmd = STDIN.gets.chomp

		if cmd == "t"
			sameCode = true
			break
		elsif cmd == "n"
			sameCode = nil
			break
		elsif cmd == "f"
			break
		elsif cmd == "v"
			puts "vim #{get_src_path(apk1_path)} -c \"vsplit #{get_src_path(apk2_path)}\" "
			system "vim #{get_src_path(apk1_path)} -c \"vsplit #{get_src_path(apk2_path)}\" "
		end
	end

	log_result(LOG_FILE, pair, res, looksSimilar, sameCode)

	puts 'press d to delete repos'
	cmd = STDIN.gets.chomp
	
	if cmd == "d"
		rm_cloned_dir(get_apk_dir(pair[0]).to_s + "1")
		rm_cloned_dir(get_apk_dir(pair[1]))
#		rm_cloned_dir("tmp")
		puts 'repos deleted'
	end
end
