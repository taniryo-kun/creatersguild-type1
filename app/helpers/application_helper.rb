#coding: utf-8
module ApplicationHelper
  def nl_to_br(str)
    str.gsub(/\r\n|\r|\n/, "<br/>")
  end
  
  def f_time(time)
    time.strftime("%Y年%m月%d日 %H:%M:%S")
  end
  
  # 連番付き文字列生成用ヘルパー
  # 引数：
  #   引数名 | 意味              | 初期値
  #   from   | 連番が始まる数値  | 1
  #   to     | 連番が終わる数値  | 1
  #   digit  | "0"で埋める桁数   | 0 (無効)
  #   prefix | 接頭辞            | "" (無効)
  #   suffix | 接尾辞            | "" (無効)
  # 使用例：
  # serial_string(from: 50, to: 100, digit: 3, prefix: "test_")
  #  ↓
  # "test_065"
  def serial_string(args={})
    args = {
      from: 1,
      to: 1,
      prefix: "",
      suffix: "",
      digit: 0
    }.merge(args)
    
    i = args[:to] - args[:from] + 1
    output = rand(i) + args[:from]
    output = output.to_s
    if args[:digit] != 0
      output = output.rjust(args[:digit], "0")
    end
    output = args[:prefix] + output + args[:suffix]
  end
end
