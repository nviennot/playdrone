Signal.trap 'SIGUSR2' do
  Thread.new do
    Thread.list.each do |thread|
      next if Thread.current == thread

      Rails.logger.info  '----[ Threads ]----' + '-' * (100-19)
      if thread.backtrace
        Rails.logger.info "Thread #{thread} #{thread['label']}"
        Rails.logger.info thread.backtrace.join("\n")
      else
        Rails.logger.info "Thread #{thread} #{thread['label']} -- no backtrace"
      end
    end
  end
end
