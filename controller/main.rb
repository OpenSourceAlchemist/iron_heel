module IronHeel
  class Main < Controller
    map '/'
    before_all{ authenticate }

    def authenticate
      auth = request.env["HTTP_AUTHORIZATION"].split.last
      @user, password = auth.unpack('m').first.split(":")
      respond('Forbidden', 403) unless User.first(:username.ilike(@user))
    rescue => ex
      Ramaze::Log.error(ex)
      respond('Forbidden', 403)
    end

    def index
      #format = '%Y-%m-%d'

      #first = Recording.order_by(:timestamp.desc).first
      #last  = Recording.order_by(:timestamp.asc).first

      #@from, @to = [first, last].compact.map{|time| time.strftime(format) }
      #redirect :search
    end

    def search
      # Welcome to Ramaze's ugliest controller method

      request.to_ivs(:date_start, :time_start, :date_end, :time_end, :exten,
                     :number, :direction)
      from = datetime(*@date_start.split('-'), *@time_start.split(':'))
      to   = datetime(  *@date_end.split('-'),   *@time_end.split(':'))

      exten  = @exten unless @exten.to_s == ""
      number = @number unless @number.to_s == ""

      dataset = Recording.filter{|o|
        ~{o.lost => true} &
         (o.timestamp >= from) &
         (o.timestamp <= to)
      }.order_by(:timestamp)

      if @direction =~ /in|out/i # If we want to limit by direction
        dataset = dataset.filter(direction: @direction)
      end

      dataset =
        if !exten && !number
          dataset
        elsif exten && !number
          dataset.where('(src ILIKE ? or dst ILIKE ?)', exten, exten)
        elsif !exten && number
          dataset.where('(src ILIKE ? or dst ILIKE ?)', number, number)
        else
          dataset.where(
            '(src ILIKE ? or dst ILIKE ?) and (src ILIKE ? or dst ILIKE ?)',
            number, number, exten, exten
          )
        end

      @recordings = paginate(dataset, limit: 20)
    end

    def play_stereo(id)
      recording = Recording[id]

      if recording.authorized_listener?(@user)
        send_file recording
        ""
      else
        "You are not authorized to listen to this recording"
      end
    end

    def play_mono(id)
      recording = Recording[id]

      if recording.authorized_listener?(@user)
        send_mono_file recording
        ""
      else
        "You are not authorized to listen to this recording"
      end
    end

    private

    def send_file(recording)
      raise "Supposed to be a Recording!" unless recording.kind_of?(Recording)
      raise "File does not exist!: #{recording.wavfile}|#{recording.speexfile}" unless File.exists?(recording.current_file)

      filename = recording.to_wav.to_s

      Ramaze::Log.info "Setting headers for #{filename}"
      response['Content-Type'] = "audio/wav"
      response['Content-Disposition'] = "attachment; filename=\"#{File.basename(filename)}\""
      response["X-Sendfile"] = filename
      response['Content-Length'] = File.size(filename)
      Ramaze::Log.info "Headers after setting: #{response.headers.inspect}"
    end

    def send_mono_file(recording)
      raise "Supposed to be a Recording!" unless recording.kind_of?(Recording)
      raise "File does not exist!: #{recording.wavfile}|#{recording.speexfile}" unless File.exists?(recording.current_file)

      filename = recording.to_mono.to_s

      Ramaze::Log.info "Setting headers for #{filename}"
      response['Content-Type'] = "audio/wav"
      response['Content-Disposition'] = "attachment; filename=\"#{File.basename(filename)}\""
      response["X-Sendfile"] = filename
      response['Content-Length'] = File.size(filename)
      Ramaze::Log.info "Headers after setting: #{response.headers.inspect}"
    end

    def datetime(*args)
      DateTime.new(*args.map(&:to_i))
    end
  end
end
