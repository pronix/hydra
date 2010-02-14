class DownloadingFile < ActiveRecord::Base
  belongs_to :task

  def complete
    true == status
  end
  alias :complete? :complete
  class << self
    @tell = Aria2cRcp.tell
    @active = @tell[:active].map {|x|
      { :gid => x["gid"],                    :speed => x["downloadSpeed"],
        :total_length => x["totalLength"] ,  :completed_length => x["completedLength"]}}

    DownloadingFile.transaction do
      @active.each {|x|
        @dwn_file = find_by_gid(x[:gid])
        @dwn_file.update_attributes({ :speed => x[:speed],
                                      :total_length => x[:total_length],
                                      :completed_length => x[:completed_length]  })
      }

    end
  end
end
