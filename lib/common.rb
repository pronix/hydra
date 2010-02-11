module Common
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
