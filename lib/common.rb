module Common
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
    ARHIVE, FILE = %w(arhive file)
    def self.options_for_select
      [ [I18n.t("rename_arhive"), ARHIVE],
        [I18n.t("rename_extracted_file"), FILE ] ]
    end

    def self.valid_options
      [ ARHIVE, FILE]
    end
  end

  module Host
    MEDIAVALISE    = "mediavalise.com"
    IMAGEVENUE     = "imagevenue.com"
    IMAGEBAM       = "imagebam.com"
    PIXHOST        = "pixhost.org"
    STOOORAGE      = "stooorage.com"

    def self.options_for_select
      [
       [MEDIAVALISE, MEDIAVALISE],
       [IMAGEVENUE, IMAGEVENUE ],
       [IMAGEBAM,   IMAGEBAM ],
       [PIXHOST,    PIXHOST ],
       [STOOORAGE,  STOOORAGE ],

      ]
    end
    def self.valid_options
      [
       MEDIAVALISE, IMAGEVENUE, IMAGEBAM, PIXHOST, STOOORAGE
      ]
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
  end

  module FileFormat
    JPG="jpg"
    PNG="png"
    def self.options_for_select
      [[JPG, JPG],[ PNG, PNG]]
    end
    def self.valid_options
      [JPG, PNG ]
    end
  end

end
