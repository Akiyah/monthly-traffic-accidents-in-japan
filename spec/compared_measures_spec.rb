require './lib/compared_measures.rb'

RSpec.describe ComparedMeasures do
  context ".map_sheet_row" do
    let(:sheets) { { monthly: 'monthly_sheet', yearly: 'yearly_sheet' } }
    let(:columns) do
      {
        value: {
          accidents: 'A',
          fatalities: 'B',
          injuries: 'C'
        },
        change: {
          accidents: 'D',
          fatalities: 'E',
          injuries: 'F'
        }
      }
    end

    let(:block_values) do
      {
        'monthly_sheet' => {
          'A' => 1,
          'B' => 2,
          'C' => 3,
          'D' => 4,
          'E' => 5,
          'F' => 6
        },
        'yearly_sheet' => {
          'A' => 7,
          'B' => 8,
          'C' => 9,
          'D' => 10,
          'E' => 11,
          'F' => 12
        }
      }
    end

    it do
      compared_measures = ComparedMeasures.map_sheet_row(sheets, columns) do |sheet, column|
        block_values[sheet][column]
      end

      expect(compared_measures.monthly_value.to_a).to eq [1, 2, 3]
      expect(compared_measures.yearly_value.to_a).to eq [7, 8, 9]
      expect(compared_measures.monthly_change.to_a).to eq [4, 5, 6]
      expect(compared_measures.yearly_change.to_a).to eq [10, 11, 12]
    end
  end

  context ".sum" do
    context "all exists" do
      let(:prefectures) do
        {
          'prefecture1' => ComparedMeasures.new(
            Measures.new(1, 2, 3),
            Measures.new(7, 8, 9),
            Measures.new(4, 5, 6),
            Measures.new(10, 11, 12)
          ),
          'prefecture2' => ComparedMeasures.new(
            Measures.new(10, 20, 30),
            Measures.new(70, 80, 90),
            Measures.new(40, 50, 60),
            Measures.new(100, 110, 120)
          )
        }
      end

      it do
        compared_measures = ComparedMeasures.sum(prefectures)

        expect(compared_measures.monthly_value.to_a).to eq [11, 22, 33]
        expect(compared_measures.yearly_value.to_a).to eq [77, 88, 99]
        expect(compared_measures.monthly_change.to_a).to eq [44, 55, 66]
        expect(compared_measures.yearly_change.to_a).to eq [110, 121, 132]
      end
    end

    context "nil" do
      let(:prefectures) do
        {
          'prefecture1' => ComparedMeasures.new(
            Measures.new(1, 2, 3),
            Measures.new(7, 8, 9),
            Measures.new(4, 5, 6),
            Measures.new(10, 11, 12)
          ),
          'prefecture2' => ComparedMeasures.new(
            Measures.new(10, 20, 30),
            Measures.new(70, 80, 90)
          )
        }
      end

      it do
        compared_measures = ComparedMeasures.sum(prefectures)

        expect(compared_measures.monthly_value.to_a).to eq [11, 22, 33]
        expect(compared_measures.yearly_value.to_a).to eq [77, 88, 99]
        expect(compared_measures.monthly_change.to_a).to eq [nil, nil, nil]
        expect(compared_measures.yearly_change.to_a).to eq [nil, nil, nil]
      end
    end
  end

  context ".create_from_block" do
    let(:block_values) do
      {
        monthly: {
          value: {
            accidents: 1,
            fatalities: 2,
            injuries: 3
          },
          change: {
            accidents: 4,
            fatalities: 5,
            injuries: 6
          }
        },
        yearly: {
          value: {
            accidents: 7,
            fatalities: 8,
            injuries: 9
          },
          change: {
            accidents: 10,
            fatalities: 11,
            injuries: 12
          }
        }
      }
    end

    it do
      compared_measures = ComparedMeasures.create_from_block do |term, type, v_key|
        block_values[term][type][v_key]
      end

      expect(compared_measures.monthly_value.to_a).to eq [1, 2, 3]
      expect(compared_measures.yearly_value.to_a).to eq [7, 8, 9]
      expect(compared_measures.monthly_change.to_a).to eq [4, 5, 6]
      expect(compared_measures.yearly_change.to_a).to eq [10, 11, 12]
    end
  end

  context ".create_from_a" do
    it do
      compared_measures = ComparedMeasures.create_from_a((1..12).to_a)

      expect(compared_measures.monthly_value.to_a).to eq [1, 2, 3]
      expect(compared_measures.yearly_value.to_a).to eq [4, 5, 6]
      expect(compared_measures.monthly_change.to_a).to eq [7, 8, 9]
      expect(compared_measures.yearly_change.to_a).to eq [10, 11, 12]
    end
  end

  context "#initialize" do
    it do
      compared_measures = ComparedMeasures.new(
        Measures.new(1, 2, 3),
        Measures.new(7, 8, 9),
        Measures.new(4, 5, 6),
        Measures.new(10, 11, 12)
      )

      expect(compared_measures.monthly_value.to_a).to eq [1, 2, 3]
      expect(compared_measures.yearly_value.to_a).to eq [7, 8, 9]
      expect(compared_measures.monthly_change.to_a).to eq [4, 5, 6]
      expect(compared_measures.yearly_change.to_a).to eq [10, 11, 12]
    end
  end

  context "#to_a" do
    it do
      compared_measures = ComparedMeasures.create_from_a((1..12).to_a)

      expect(compared_measures.to_a).to eq [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    end
  end

  context "#get" do
    it do
      compared_measures = ComparedMeasures.create_from_a((1..12).to_a)

      expect(compared_measures.get(:monthly, :value).to_a).to eq [1, 2, 3]
      expect(compared_measures.get(:yearly, :value).to_a).to eq [4, 5, 6]
      expect(compared_measures.get(:monthly, :change).to_a).to eq [7, 8, 9]
      expect(compared_measures.get(:yearly, :change).to_a).to eq [10, 11, 12]
    end

    context "alias name" do
      it do
        compared_measures = ComparedMeasures.create_from_a((1..12).to_a)

        expect(compared_measures.monthly_value.to_a).to eq [1, 2, 3]
        expect(compared_measures.yearly_value.to_a).to eq [4, 5, 6]
        expect(compared_measures.monthly_change.to_a).to eq [7, 8, 9]
        expect(compared_measures.yearly_change.to_a).to eq [10, 11, 12]
      end
    end
  end

  context "#set" do
    it do
      compared_measures = ComparedMeasures.create_from_a((1..12).to_a)

      compared_measures.set(:monthly, :value, Measures.new(10, 20, 30))
      compared_measures.set(:yearly, :value, Measures.new(70, 80, 90))
      compared_measures.set(:monthly, :change, Measures.new(40, 50, 60))
      compared_measures.set(:yearly, :change, Measures.new(100, 110, 120))

      expect(compared_measures.monthly_value.to_a).to eq [10, 20, 30]
      expect(compared_measures.yearly_value.to_a).to eq [70, 80, 90]
      expect(compared_measures.monthly_change.to_a).to eq [40, 50, 60]
      expect(compared_measures.yearly_change.to_a).to eq [100, 110, 120]
    end

    context "alias name" do
      it do
        compared_measures = ComparedMeasures.create_from_a((1..12).to_a)

        compared_measures.monthly_value = Measures.new(10, 20, 30)
        compared_measures.yearly_value = Measures.new(70, 80, 90)
        compared_measures.monthly_change = Measures.new(40, 50, 60)
        compared_measures.yearly_change = Measures.new(100, 110, 120)

        expect(compared_measures.monthly_value.to_a).to eq [10, 20, 30]
        expect(compared_measures.yearly_value.to_a).to eq [70, 80, 90]
        expect(compared_measures.monthly_change.to_a).to eq [40, 50, 60]
        expect(compared_measures.yearly_change.to_a).to eq [100, 110, 120]
      end
    end
  end

  context "#fill_monthly_measures" do
    let(:compared_measures) do
      ComparedMeasures.new(
        Measures.new(nil, nil, nil),
        Measures.new(160, 16, 210),
        Measures.new(nil, nil, nil),
        Measures.new(-32, -4, -42)
      )
    end

    let(:compared_measures1) do
      ComparedMeasures.new(
        Measures.new(50, 5, 60),
        Measures.new(150, 15, 180),
        Measures.new(-10, -1, -11),
        Measures.new(-30, -3, -33)
      )
    end

    it do
      compared_measures2 = compared_measures.fill_monthly_measures(compared_measures1)

      expect(compared_measures2.monthly_value.to_a).to eq [160-150, 16-15, 210-180]
      expect(compared_measures2.yearly_value.to_a).to eq [160, 16, 210]
      expect(compared_measures2.monthly_change.to_a).to eq [-32+30, -4+3, -42+33]
      expect(compared_measures2.yearly_change.to_a).to eq [-32, -4, -42]
    end
  end

  context "#last_year" do
    let(:compared_measures) do
      ComparedMeasures.new(
        Measures.new(50, 5, 60),
        Measures.new(150, 15, 180),
        Measures.new(-10, -1, -11),
        Measures.new(-30, -3, -33)
      )
    end

    it do
      compared_measures2 = compared_measures.last_year

      expect(compared_measures2.monthly_value.to_a).to eq [50+10, 5+1, 60+11]
      expect(compared_measures2.yearly_value.to_a).to eq [150+30, 15+3, 180+33]
      expect(compared_measures2.monthly_change.to_a).to eq [nil, nil, nil]
      expect(compared_measures2.yearly_change.to_a).to eq [nil, nil, nil]
    end
  end

  context "#next_month" do
    let(:cm) do
      ComparedMeasures.new(
        Measures.new(50, 5, 60),
        Measures.new(150, 15, 180)
      )
    end

    let(:cm_next_next_month) do
      ComparedMeasures.new(
        Measures.new(70, 7, 80),
        Measures.new(210, 21, 240)
      )
    end

    it do
      cm_next_month = cm.next_month(cm_next_next_month)

      expect(cm_next_month.monthly_value.to_a).to eq [210-70-150, 21-7-15, 240-80-180]
      expect(cm_next_month.yearly_value.to_a).to eq [210-70, 21-7, 240-80]
    end
  end
end
