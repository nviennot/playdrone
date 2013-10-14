def rm_cloned_dir (cloned_dir_name)
	rm_output = `rm -rf #{cloned_dir_name}`	
	rm_result=$?.success?
	rm_result
end

def unzip_apk (apk_path)
	cert_output = `unzip -l #{apk_path} META-INF/* |grep -o "META-INF/.*"`
	cert_result=$?.success?
	cert_result
end

def get_MD5 (apk_path)
	cert_output = `unzip -p #{apk_path} **.RSA **.DSA | keytool -printcert | grep MD5`
	start_idx = (cert_output =~ /MD5:/)
	if start_idx
		md5 = cert_output[start_idx+6..-1]
	else
		md5 = false
	end
	md5 	
end

def clone_dir (git_file_path)
	clone_output = `git clone -b apk #{git_file_path}`
	result=$?.success?
	if !result
		puts clone_output
	end
	result
end

def count_cert_files (cert_output)
	cert_array = cert_output.gsub(/\s+/m, ' ').strip.split(" ")
	cert_array.each { |cert| 
		if certs_dict[cert]
			certs_dict[cert] = certs_dict[cert] + 1
		else 
			certs_dict[cert] = 1
		end
	}
end 

t1 = Time.now
counter = 0
failed = 0 
file = File.new("/scratch/space/nv2159/sync", "r")
out_file = File.new("auth_sig170_5000.csv", 'w') 
#fail_file = File.new("failed_clone", 'w') 
certs_dict = {}

#while (counter < 5000)
while (line = file.gets)
	if (counter % 170) == 0 
		tokens = line.split(' ')
		git_file_path = tokens.last
		apk_id = git_file_path[28..-5].gsub!('/','.')

		if clone_dir(git_file_path)
			cloned_dir_path = apk_id.split('.')[-1]
			apk_path = Dir["#{cloned_dir_path}/*apk"].first

			md5 = false
			count = 0
			while !md5 and count < 3
				md5 = get_MD5(apk_path)
				sleep 1
				count = count + 1
			end

			if md5
				out_file.puts "#{apk_id} #{md5}"
			else
				out_file.puts "#{apk_id} XXXXXXXX"
				failed = failed + 1
			#	puts "#{git_file_path} #{apk_path}"
			end
			
			rm_cloned_dir(cloned_dir_path)
		else
			out_file.puts "#{apk_id} FFFFFFFFF"
			failed = failed + 1
		end

		#puts "------------------------------------------"
		#puts "#{counter}: #{file_path}, #{clone_output}, #{cloned_dir_name}, #{result}"
		#puts "#{counter}: #{apk_name}, #{cert_output}, #{cert_result}"
	end
	counter = counter + 1
end
file.close
out_file.close
t2 = Time.now
time = t2 - t1

puts "Time elapsed: #{time}"
puts "#{time/counter} seconds per apk"
puts "#{counter} apps, #{failed} apps failed to clone" 
#certs_dict.each {|key, value| puts "#{key} is #{value}"}
