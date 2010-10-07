class Notice
    @@STACK = {}
    @@width = nil

    STATES = {
        :busy   => "\x1B[1m[\x1B[0m\x1B[34mBUSY\x1B[0m\x1B[1m]\x1B[0m",
        :fail   => "\x1B[1m[\x1B[0m\x1B[1;31mFAIL\x1B[0m\x1B[1m]\x1B[0m",
        :done   => "\x1B[1m[\x1B[0m\x1B[1;32mDONE\x1B[0m\x1B[1m]\x1B[0m"
    }

    def initialize(name, &block)
        @@width ||= get_width
        line = create_line(name.dup)
        @@STACK[name.to_s] ||= lambda { true }
        @@STACK[name.to_s] = block if block
        STDOUT.print line + STATES[:busy]
        STDOUT.print "\r#{line}#{(@@STACK[name.to_s].call ? STATES[:done] : STATES[:fail])}\n"
    end

    def create_line(name)
        name = if name.size > (@@width - 10)
            name.gsub(/^(.{#{@@width - 10}}).*$/, '\1...')
        else
            name.ljust(@@width - 10, ' ')
        end
        " \x1B[1;34m::\x1B[0m \x1B[1m#{name}\x1B[0m"
    end

    def get_width
        default = 80
        begin
            tiocgwinsz = 0x5413
            data = [0, 0, 0, 0].pack('SSSS')
            if STDOUT.ioctl(tiocgwinsz, data) >= 0
                rows, cols, xpixels, ypixels = data.unpack('SSSS')
                (cols >= 0 ? cols : default)
            else
                default
            end
        rescue Exception => e
            default
        end
    end
end

def notice(name, &block)
    Notice.new(name, &block)
end
