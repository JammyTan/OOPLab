require 'rails/rack/logger'

class RedLogger
    SEVERITY_TO_COLOR_MAP = {'DEBUG' => '0;37', 'INFO' => '32', 'WARN' => '33', 'ERROR' => '31', 'FATAL' => '31', 'UNKNOWN' => '37', 'EXCEP' => '95'}

    def initialize
        @logger = 'STDOUT'

    end

    def debug(msg)
        if @logger == 'STDOUT'
            call('DEBUG', msg)
        else
            Rails.logger.debug(msg)
        end
    end

    def info(msg)
        if @logger == 'STDOUT'
            call('INFO', msg)
        else
            Rails.logger.info(msg)
        end
    end

    def error(msg)
        if @logger == 'STDOUT'
            call('ERROR', msg)
        else
            Rails.logger.error(msg)
        end
    end

    def warn(msg)
        if @logger == 'STDOUT'
            call('WARN', msg)
        else
            Rails.logger.warn(msg)
        end
    end

    def fatal(msg)
        if @logger == 'STDOUT'
            call('FATAL', msg)
        else
            Rails.logger.fatal(msg)
        end
    end

    def exception(exception)
        msg = "#{exception.class} (#{exception.message}):\n    " +
            exception.backtrace.join("\n    ")
        if @logger == 'STDOUT'
            call('EXCEP', msg)
        else
            Rails.logger.fatal(msg)
        end
    rescue => e
        print e.to_s
    end

    private

    def call(severity, msg)
        time = Time.now
        formatted_severity = sprintf("%-5s", "#{severity}")
        formatted_time = time.strftime("%Y-%m-%d %H:%M:%S.") << time.usec.to_s[0..2].rjust(3)
        color = SEVERITY_TO_COLOR_MAP[severity]
        printf("\033[0;37m#{formatted_time}\033[0m [\033[#{color}m#{formatted_severity}\033[0m] #{msg.strip} (pid:#{$$})\n")
    end


end
Log = RedLogger.new()