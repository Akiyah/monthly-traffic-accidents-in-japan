require 'roo'
require 'roo-xls'

class Reader
  def read(filename, sheets)
    if filename.end_with?('xlsx')
      excel = Roo::Excelx.new(filename)
    else
      excel = Roo::Excel.new(filename)
    end

    data = {}
    area_prefecture.each do |area, prefectures|
      prefectures.each do |prefecture, i|
        data[area] ||= {}
        data[area][prefecture] = {
          v0: sheets[0] ? excel.sheet(sheets[0]).cell(i, columns[:v0]).to_i : nil,
          v1: sheets[0] ? excel.sheet(sheets[0]).cell(i, columns[:v1]).to_i : nil,
          v2: sheets[0] ? excel.sheet(sheets[0]).cell(i, columns[:v2]).to_i : nil,
          v3: sheets[1] ? excel.sheet(sheets[1]).cell(i, columns[:v0]).to_i : nil,
          v4: sheets[1] ? excel.sheet(sheets[1]).cell(i, columns[:v1]).to_i : nil,
          v5: sheets[1] ? excel.sheet(sheets[1]).cell(i, columns[:v2]).to_i : nil,
        }
      end
    end
    data
  end
end

class ReaderA < Reader
  def area_prefecture
    {
      "北海道" => {
        "札幌" =>  6,
        "函館" =>  7,
        "旭川" =>  8,
        "釧路" =>  9,
        "北見" => 10,
        "計" => 11,
      },
      "東北" => {
        "青森" => 12,
        "岩手" => 13,
        "宮城" => 14,
        "秋田" => 15,
        "山形" => 16,
        "福島" => 17,
      },
      "東京" => {
        "東京" => 19,
      },
      "関東" => {
        "茨城" => 20,
        "栃木" => 21,
        "群馬" => 22,
        "埼玉" => 23,
        "千葉" => 24,
        "神奈川" => 25,
        "新潟" => 26,
        "山梨" => 27,
        "長野" => 28,
        "静岡" => 29,
      },
      "中部" => {
        "富山" => 31,
        "石川" => 32,
        "福井" => 33,
        "岐阜" => 34,
        "愛知" => 35,
        "三重" => 36,
      },
      "近畿" => {
        "滋賀" => 38,
        "京都" => 39,
        "大阪" => 40,
        "兵庫" => 41,
        "奈良" => 42,
        "和歌山" => 43,
      },
      "中国" => {
        "鳥取" => 45,
        "島根" => 46,
        "岡山" => 47,
        "広島" => 48,
        "山口" => 49,  
      },
      "四国" => {
        "徳島" => 51,
        "香川" => 52,
        "愛媛" => 53,
        "高知" => 54,
      
      },
      "九州" => {
        "福岡" => 56,
        "佐賀" => 57,
        "長崎" => 58,
        "熊本" => 59,
        "大分" => 60,
        "宮崎" => 61,
        "鹿児島" => 62,
        "沖縄" => 63,
      },
    }
  end

  def columns
    {
      v0: 'C',
      v1: 'F',
      v2: 'J',
    }
  end
end

class ReaderB < Reader
  def area_prefecture
    {
      "北海道" => {
        "計" => 6,
      },
      "東北" => {
        "青森" =>  7,
        "岩手" =>  8,
        "宮城" =>  9,
        "秋田" => 10,
        "山形" => 11,
        "福島" => 12,
      },
      "東京" => {
        "東京" => 13,
      },
      "関東" => {
        "茨城" => 14,
        "栃木" => 15,
        "群馬" => 16,
        "埼玉" => 17,
        "千葉" => 18,
        "神奈川" => 19,
        "新潟" => 20,
        "山梨" => 21,
        "長野" => 22,
        "静岡" => 23,
      },
      "中部" => {
        "富山" => 24,
        "石川" => 25,
        "福井" => 26,
        "岐阜" => 27,
        "愛知" => 28,
        "三重" => 29,
      },
      "近畿" => {
        "滋賀" => 30,
        "京都" => 31,
        "大阪" => 32,
        "兵庫" => 33,
        "奈良" => 34,
        "和歌山" => 35,
      },
      "中国" => {
        "鳥取" => 36,
        "島根" => 37,
        "岡山" => 38,
        "広島" => 39,
        "山口" => 40,  
      },
      "四国" => {
        "徳島" => 41,
        "香川" => 42,
        "愛媛" => 43,
        "高知" => 44,
      
      },
      "九州" => {
        "福岡" => 45,
        "佐賀" => 46,
        "長崎" => 47,
        "熊本" => 48,
        "大分" => 49,
        "宮崎" => 50,
        "鹿児島" => 51,
        "沖縄" => 52,
      },
    }
  end

  def columns
    {
      v0: 'I',
      v1: 'J',
      v2: 'K',
    }
  end
end
