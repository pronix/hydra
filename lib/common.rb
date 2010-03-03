module Common
  module RenameMacros
    # ["[file_name]", "[text]", "[part_number]", "[ext]"]
    FILE_NAME = "[file_name]"
    TEXT= "[text]"
    PART_NUMBER = "[part_number]"
    EXT = "[ext]"
    def self.list
      [FILE_NAME, TEXT, PART_NUMBER, EXT]
    end
  end
  module Font

    def self.list
      unless @font_list
        @font_list = IO.popen("identify -list font").readlines.select {|x| x[/Font/]}.map{|x| x[/Font: (.*)/] && $1 }
      end
      @font_list
    end

    def self.options_for_select
      list.map{ |x| [x,x]}
    end
    def self.valid_options
      list
    end

  end

  module Video
    def self.mime_type
      [
       'application/x-mp4',
       'video/mpeg',
       'video/quicktime',
       'video/x-la-asf',
       'video/x-ms-asf',
       'video/x-msvideo',
       'video/x-sgi-movie',
       'video/x-flv',
       'flv-application/octet-stream',
       'video/3gpp',
       'video/3gpp2',
       'video/3gpp-tt',
       'video/BMPEG',
       'video/BT656',
       'video/CelB',
       'video/DV',
       'video/H261',
       'video/H263',
       'video/H263-1998',
       'video/H263-2000',
       'video/H264',
       'video/JPEG',
       'video/MJ2',
       'video/MP1S',
       'video/MP2P',
       'video/MP2T',
       'video/mp4',
       'video/MP4V-ES',
       'video/MPV',
       'video/mpeg4',
       'video/mpeg4-generic',
       'video/nv',
       'video/parityfec',
       'video/pointer',
       'video/raw',
       'video/rtx',
      ]
    end
  end

  module ContentType
    ADULT = 1
    FAMILY = 2
    def self.options_for_select
      [
       [I18n.t("adult_content"),ADULT],
       [I18n.t("family_safe"),FAMILY],
      ]
    end
    def self.valid_options
      [ ADULT, FAMILY]
    end
    def self.values
      {
        ADULT   => I18n.t("adult_content"),
        FAMILY  => I18n.t("family_safe")
      }

    end
  end

  module ThatRename
    ARCHIVE, FILE = %w(archive file)
    def self.options_for_select
      [ [I18n.t("rename_archive"), ARCHIVE],
        [I18n.t("rename_extracted_file"), FILE ] ]
    end

    def self.valid_options
      [ ARCHIVE, FILE]
    end
  end

  module Host
    MEDIAVALISE        = "hadoop.adenin.ru" #RAILS_ENV["production"] ? "mediavalise.com" : "hadoop.adenin.ru"
    IMAGEVENUE         = "imagevenue.com"
    IMAGEBAM           = "imagebam.com"
    PIXHOST            = "pixhost.org"
    STOOORAGE          = "stooorage.com"

    def self.must_have_login_password
      [ MEDIAVALISE, IMAGEVENUE, IMAGEBAM ]
    end
    def self.options_for_select
      [
       ["MediaValise.com", MEDIAVALISE],
       [IMAGEVENUE, IMAGEVENUE ],
       [IMAGEBAM,   IMAGEBAM ],
       [PIXHOST,    PIXHOST ],
       [STOOORAGE,  STOOORAGE ],

      ]
    end
    def self.valid_options
      [ MEDIAVALISE, IMAGEVENUE, IMAGEBAM , PIXHOST, STOOORAGE ]
    end
  end


  module PositionTimestamp
    LEFT='left'
    RIGHT='right'
    def self.options_for_select
      [[I18n.t(LEFT), LEFT],[ I18n.t(RIGHT), RIGHT]]
    end
    def self.valid_options
      [LEFT, RIGHT]
    end
    def self.values
      {
        LEFT =>  "SouthWest",
        RIGHT => "SouthEast"
      }
    end
  end

  module FileFormat
    JPG="jpeg"
    PNG="png"
    def self.options_for_select
      [[JPG, JPG],[ PNG, PNG]]
    end
    def self.valid_options
      [JPG, PNG ]
    end
  end

end
