# bundle exec ruby -Itest test/03_method/test_define.rb
# Q1.
# 次の動作をする A1 class を実装する
# - "//" を返す "//"メソッドが存在すること
class A1
  define_method "//" do
    "//"
  end
end

# Q2.
# 次の動作をする A2 class を実装する
# - 1. "SmartHR Dev Team"と返すdev_teamメソッドが存在すること
# - 2. initializeに渡した配列に含まれる値に対して、"hoge_" をprefixを付与したメソッドが存在すること
# - 2で定義するメソッドは下記とする
#   - 受け取った引数の回数分、メソッド名を繰り返した文字列を返すこと
#   - 引数がnilの場合は、dev_teamメソッドを呼ぶこと
# - また、2で定義するメソッドは以下を満たすものとする
#   - メソッドが定義されるのは同時に生成されるオブジェクトのみで、別のA2インスタンスには（同じ値を含む配列を生成時に渡さない限り）定義されない
class A2
  def initialize(array)
    @array = array
    array.each do |word|
      define_hoge(word)
    end
  end

  def dev_team
    "SmartHR Dev Team"
  end

  def define_hoge(word)
    method_name = "hoge_#{word}"
    define_singleton_method method_name do |arg|
      return dev_team unless arg
      return method_name * arg
    end
  end
end


# Q3.
# 次の動作をする OriginalAccessor モジュール を実装する
# - OriginalAccessorモジュールはincludeされたときのみ、my_attr_accessorメソッドを定義すること
# - my_attr_accessorはgetter/setterに加えて、boolean値を代入した際のみ真偽値判定を行うaccessorと同名の?メソッドができること

module OriginalAccessor
  def self.included(klass)
    klass.define_singleton_method :my_attr_accessor do |arg| # :hoge
      define_method arg do # hoge
        instance_variable_get("@#{arg.to_s}") # @hoge
      end
      # self.singleton_class.ancestors
      define_method "#{arg.to_s}=" do |set_value| # hoge=
        instance_variable_set("@#{arg.to_s}", set_value) # @hoge = 1
        if [TrueClass, FalseClass].include?(set_value.class)
          define_singleton_method "#{arg.to_s}?", ->{set_value}
        end
      end
    end
  end
end
