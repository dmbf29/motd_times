class Episode
  # MOTD => m0007fnr / MOTD2 => m0007m8m
  attr_reader :time, :show, :past

  def initialize(attributes = {})
    @time = attributes[:time]
    @show = attributes[:show]
    @past = attributes[:past]
    @reddit = attributes[:reddit]
  end

end
