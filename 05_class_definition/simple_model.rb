#  bundle exec ruby -Itest test/05_class_definition/test_simple_record.rb

# 次の仕様を満たす、SimpleModelモジュールを作成してください
#
# 1. include されたクラスがattr_accessorを使用すると、以下の追加動作を行う
#   1. 作成したアクセサのreaderメソッドは、通常通りの動作を行う
#   2. 作成したアクセサのwriterメソッドは、通常に加え以下の動作を行う
#     1. 何らかの方法で、writerメソッドを利用した値の書き込み履歴を記憶する
#     2. いずれかのwriterメソッド経由で更新をした履歴がある場合、 `true` を返すメソッド `changed?` を作成する
#     3. 個別のwriterメソッド経由で更新した履歴を取得できるメソッド、 `ATTR_changed?` を作成する
#       1. 例として、`attr_accessor :name, :desc`　とした時、このオブジェクトに対して `obj.name = 'hoge` という操作を行ったとする
#       2. `obj.name_changed?` は `true` を返すが、 `obj.desc_changed?` は `false` を返す
#       3. 参考として、この時 `obj.changed?` は `true` を返す
# 2. initializeメソッドはハッシュを受け取り、attr_accessorで作成したアトリビュートと同名のキーがあれば、自動でインスタンス変数に記録する
#   1. ただし、この動作をwriterメソッドの履歴に残してはいけない
# 3. 履歴がある場合、すべての操作履歴を放棄し、値も初期状態に戻す `restore!` メソッドを作成する

module SimpleModel
  def self.included(including_class) # 引数はincludeしたclass名が入る
    def including_class.attr_accessor(*attr_names)
      # history = {name:false, description: false}
      # initial_values = {name: 'hoge', description: 'fuga'}
      attr_names.each do |attr_name|
        # writerを定義する
        define_method("#{attr_name.to_s}=", ) do |set_value|
          instance_variable_set("@#{attr_name.to_s}", set_value)
          # 履歴を更新する
          @history[attr_name] = true
        end

        # readerを定義する
        define_method("#{attr_name.to_s}", ) do
          instance_variable_get("@#{attr_name.to_s}")
        end

        # ATTR_changed？ の作成
        define_method("#{attr_name.to_s}_changed?") do
          !!@history[attr_name]
        end
      end
    end
  end

  def initialize(**args)
    @history = {}
    @initial_values = {}
    args.each do |k, v|
      instance_variable_set("@#{k.to_s}", v)
      @initial_values[k] = v
    end
  end

  def changed?
    @history.any? do |_k,v|
      v
    end
  end

  def restore!
    @history = {}
    @initial_values.each do |k,v|
      instance_variable_set("@#{k.to_s}", v)
    end
  end
end
