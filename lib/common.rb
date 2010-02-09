module Common
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
