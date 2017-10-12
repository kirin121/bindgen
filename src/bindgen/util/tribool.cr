module Bindgen
  module Util
    # A tribool can be in one of three states: `true`, `false` or `unset`.  Used
    # in `Configuration` to distinguish an unset (for the default) value from
    # an explicit `false`.
    #
    # The user can also use an empty value in the configuration to explicitly
    # use the default.
    #
    # Use this type in a `YAML.mapping` like this:
    #
    # ```crystal
    # my_option: {
    #   type: Util::Tribool,
    #   default: Util::Tribool.unset,
    # }
    # ```
    struct Tribool
      @value : Bool | Nil

      def initialize(@value : Bool | Nil)
      end

      def initialize(pull : YAML::PullParser)
        @value = pull.read_null_or{ Bool.new(pull) }
      end

      # Returns a new unset `Tribool`.
      def self.unset
        new(nil)
      end

      # Returns the value as `Bool`.  If this tri-bool is unset, returns the
      # *default_value*.  See also `#true?` and `#false?`.
      def get(default_value : Bool) : Bool
        value = @value

        if value.nil?
          default_value
        else
          value
        end
      end

      # Returns `true` only if this tri-bool is `true`, or if it is unset and
      # the *default_value* is.  This is semantically a alias for `#get`.
      def true?(default_value : Bool) : Bool
        get(default_value) == true
      end

      # Returns `true` only if this tri-bool is `false`, or if it is unset and
      # the *default_value* is.
      def false?(default_value : Bool) : Bool
        get(default_value) == false
      end

      # Returns `true` if this tribool is unset.
      def unset?
        @value.nil?
      end

      # Compares the value to *bool*.  If this tribool is unset, this will never
      # be `true`.  See also `#unset?`, `#true?` and `#false?`
      def ==(bool : Bool)
        @value == bool
      end

      # Compares this to the other `Tribool`.
      def ==(tri : Tribool)
        @value == tri.@value
      end
    end
  end
end
