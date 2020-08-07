require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do

  describe "#update_quality" do
    # Sample items
    let(:normal_item)         { Item.new(name="+5 Dexterity Vest", sell_in= 10, quality= 25) }
    let(:sulfuras_item)       { Item.new(name= "Sulfuras, Hand of Ragnaros", sell_in= 0, quality= 80) }
    let(:aged_brie_item)      { Item.new(name= "Aged Brie", sell_in= 10, quality= 0) }
    let(:conjured_item)       { Item.new(name= "Conjured Mana Cake", sell_in= 10, quality= 15) }
    let(:backstage_pass_item) { Item.new(name= "Backstage passes to a TAFKAL80ETC concert", sell_in= 10, quality= 20) }
    let(:days)                { 15 }

    # context "all items" do
    #    #
    #   it "lowers the sell in value by 1 once day has passed" do
    #
    #   end
    #
    # end

    context "when normal item" do
      let(:gilded_rose_object) { GildedRose.new([normal_item]) }

      it "should not have negative quality value" do
        normal_item.quality = 1
        1.upto(days) do |day|
          gilded_rose_object.update_quality
          expect(normal_item.quality).not_to be_negative
        end
        expect(normal_item.quality).not_to be_negative
      end

      it "should not have negative sell in value" do
        normal_item.sell_in = 1
        1.upto(days) do |day|
          gilded_rose_object.update_quality
          expect(normal_item.sell_in).not_to be_negative
        end
        expect(normal_item.sell_in).not_to be_negative
      end

      it "should not have quality that exceeds 50" do
        normal_item.quality = 49
        1.upto(days) do |day|
          gilded_rose_object.update_quality
          expect(normal_item.quality).not_to be > 50
        end
        expect(normal_item.quality).not_to be > 50
      end

      it "degrades the quality by 1 as time passes" do
        current_quality = normal_item.quality
        actual_days     = 3
        1.upto(actual_days) do |day|
          gilded_rose_object.update_quality
          expect(normal_item.quality).to eq (current_quality-day).abs
        end
        expect(normal_item.quality).to eq (current_quality-actual_days).abs
      end

      it "degrades the quality twice once sell in day has passed" do
        normal_item.sell_in = 1
        current_quality = normal_item.quality
        1.upto(days) do |day|
          gilded_rose_object.update_quality
          expect(normal_item.quality).to eq ([current_quality-(day * 2), 0].max).abs
        end
        expect(normal_item.quality).to eq 0
      end
    end

    context "when aged brie item" do
      let(:gilded_rose_object) { GildedRose.new([aged_brie_item]) }
      it "should not have negative quality value" do
        aged_brie_item.quality = 1
        1.upto(days) do |day|
          gilded_rose_object.update_quality
          expect(aged_brie_item.quality).not_to be_negative
        end
        expect(aged_brie_item.quality).not_to be_negative
      end

      it "should not have negative sell in value" do
        aged_brie_item.sell_in = 1
        1.upto(days) do |day|
          gilded_rose_object.update_quality
          expect(aged_brie_item.sell_in).not_to be_negative
        end
        expect(aged_brie_item.sell_in).not_to be_negative
      end

      it "should not have quality that exceeds 50" do
        aged_brie_item.quality = 49
        1.upto(days) do |day|
          gilded_rose_object.update_quality
          expect(aged_brie_item.quality).not_to be > 50
        end
        expect(aged_brie_item.quality).not_to be > 50
      end

      it "upgrades by 1 as time passes" do
        1.upto(days) do |day|
          gilded_rose_object.update_quality
          expect(aged_brie_item.quality).to eq day
        end
        expect(aged_brie_item.quality).to eq days
      end
    end

    context "when backstage pass item" do
      let(:gilded_rose_object) { GildedRose.new([backstage_pass_item]) }
      it "should not have negative quality value" do
        backstage_pass_item.quality = 1
        1.upto(days) do |day|
          gilded_rose_object.update_quality
          expect(backstage_pass_item.quality).not_to be_negative
        end
        expect(backstage_pass_item.quality).not_to be_negative
      end

      it "should not have negative sell in value" do
        backstage_pass_item.sell_in = 1
        1.upto(days) do |day|
          gilded_rose_object.update_quality
          expect(backstage_pass_item.sell_in).not_to be_negative
        end
        expect(backstage_pass_item.sell_in).not_to be_negative
      end

      it "should not have quality that exceeds 50" do
        backstage_pass_item.quality = 49
        1.upto(days) do |day|
          gilded_rose_object.update_quality
          expect(backstage_pass_item.quality).not_to be > 50
        end
        expect(backstage_pass_item.quality).not_to be > 50
      end

      it "upgrades by 1 as time passes when there's more than 10 days to sell" do
        current_quality = backstage_pass_item.quality
        backstage_pass_item.sell_in = 15
        1.upto(3) do |day|
          gilded_rose_object.update_quality
          expect(backstage_pass_item.quality).to eq (current_quality + day)
        end
        expect(backstage_pass_item.quality).to eq (current_quality + 3)
      end

      it "upgrades by 2 when there are 10 days or less left to sell and 5 days before the concert" do
        backstage_pass_item.sell_in = 10
        current_quality             = backstage_pass_item.quality
        actual_days                 = 4
        1.upto(actual_days) do |day|
          gilded_rose_object.update_quality
          expect(backstage_pass_item.quality).to eq (current_quality + (day * 2))
        end
        expect(backstage_pass_item.quality).to eq (current_quality + (actual_days * 2))
      end

      it "upgrades by 3 when there are 5 days or less left to sell" do
        backstage_pass_item.sell_in = 5
        current_quality             = backstage_pass_item.quality
        actual_days                 = 3
        1.upto(actual_days) do |day|
          gilded_rose_object.update_quality
          expect(backstage_pass_item.quality).to eq (current_quality + (day * 3))
        end
        expect(backstage_pass_item.quality).to eq (current_quality + (actual_days * 3))
      end

      it "has no quality after the sell in date" do
        backstage_pass_item.sell_in = 0
        gilded_rose_object.update_quality
        expect(backstage_pass_item.quality).to eq 0
      end
    end

    context "when conjured item" do

      it "should not have negative quality value" do
        conjured_item.quality = 1
        1.upto(days) do |day|
          gilded_rose_object.update_quality
          expect(conjured_item.quality).not_to be_negative
        end
        expect(conjured_item.quality).not_to be_negative
      end

      it "should not have negative sell in value" do
        conjured_item.sell_in = 1
        1.upto(days) do |day|
          gilded_rose_object.update_quality
          expect(conjured_item.sell_in).not_to be_negative
        end
        expect(conjured_item.sell_in).not_to be_negative
      end

      it "should not have quality that exceeds 50" do
        conjured_item.quality = 49
        1.upto(days) do |day|
          gilded_rose_object.update_quality
          expect(conjured_item.quality).not_to be > 50
        end
        expect(conjured_item.quality).not_to be > 50
      end

      let(:gilded_rose_object) { GildedRose.new([conjured_item]) }
      it "degrades faster than regular item as time passes" do
        actual_days     = 5
        current_quality = conjured_item.quality
        1.upto(actual_days) do |day|
          gilded_rose_object.update_quality
          expect(conjured_item.quality).to eq ([current_quality-(day * 2), 0].max).abs
        end
        expect(conjured_item.quality).to eq ([current_quality-(actual_days * 2), 0].max).abs
      end

      it "degrades twice as fast after the sell in date" do
        current_quality       = conjured_item.quality
        conjured_item.sell_in = 1
        1.upto(days) do |day|
          gilded_rose_object.update_quality
          expect(conjured_item.quality).to eq ([current_quality-(day * 4), 0].max).abs
        end
        expect(conjured_item.quality).to eq 0
      end
    end

    context "when sulfuras item" do

      it "should not have negative quality value" do
        sulfuras_item.quality = 1
        1.upto(days) do |day|
          gilded_rose_object.update_quality
          expect(sulfuras_item.quality).not_to be_negative
        end
        expect(sulfuras_item.quality).not_to be_negative
      end

      it "should not have negative sell in value" do
        sulfuras_item.sell_in = 1
        1.upto(days) do |day|
          gilded_rose_object.update_quality
          expect(sulfuras_item.sell_in).not_to be_negative
        end
        expect(sulfuras_item.sell_in).not_to be_negative
      end

      let(:gilded_rose_object) { GildedRose.new([sulfuras_item]) }
      it "should have a quality of 80" do
        sulfuras_item.quality = 20
        gilded_rose_object.update_quality
        expect(sulfuras_item.quality).to eq 80
      end

      it "can't be altered" do
        sulfuras_item.quality = 20
        1.upto(days) do
          gilded_rose_object.update_quality
        end
        expect(sulfuras_item.quality).to eq 80
      end
    end

  end

end
