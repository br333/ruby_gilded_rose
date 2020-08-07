class GildedRose

  # Items that have rules
  AGED_BRIE   = 'Aged Brie'
  SULFURAS    = 'Sulfuras, Hand of Ragnaros'
  PASS        = 'Backstage'
  CONJURED    = 'Conjured'

  def initialize(items)
    @items = items
  end

  def update_sell_in(item)
    item.sell_in -= 1 unless item.sell_in <= 0
    item.sell_in
  end

  def update_quality
    @items.each do |item|
      update_sell_in(item) unless item.name.eql?(SULFURAS)
      if item.name.eql?(AGED_BRIE)
        AgedBrieUpdater.new(item).update!
      elsif item.name.include?(PASS)
        BackPassesUpdater.new(item).update!
      elsif item.name.include?(CONJURED)
        ConjuredUpdater.new(item).update!
      elsif item.name.include?(SULFURAS)
        SulfurasUpdater.new(item).update!
      else
        ItemUpdater.new(item).update!
      end
    end
  end
end


class ItemUpdater
  attr_accessor :item
  # Quality Rules
  MAX_QUALITY = 50
  MIN_QUALITY = 0

  def initialize(item)
    @item = item
  end

  def update!
    if item.sell_in <= 0
      decrease_quality(2)
    else
      decrease_quality
    end
  end

  private
    def increase_quality(increase_by = 1)
      item.quality += increase_by unless item.quality >= MAX_QUALITY
      item.quality = 50 if item.quality > MAX_QUALITY
    end

    def decrease_quality(decrease_by = 1)
      item.quality -= decrease_by unless item.quality <= MIN_QUALITY
      item.quality = 0 if item.quality < MIN_QUALITY
    end
end

class AgedBrieUpdater < ItemUpdater
  def update!
    increase_quality

    # if item.sell_in <= 10
    #   increase_quality(2)
    # elsif item.sell_in <= 5
    #   increase_quality(3)
    # else
    #   increase_quality
    # end
  end
end

class BackPassesUpdater < ItemUpdater
  def update!
    if item.sell_in < 11 && item.sell_in > 5
      increase_quality(2)
    elsif item.sell_in < 6 && item.sell_in > 0
      increase_quality(3)
    elsif item.sell_in == 0
      decrease_quality(item.quality)
    else
      increase_quality(1)
    end
  end
end

class ConjuredUpdater < ItemUpdater
  def update!
    if item.sell_in <= 0
      decrease_quality(4)
    else
      decrease_quality(2)
    end
  end
end

class SulfurasUpdater < ItemUpdater
  def update!
    item.quality = 80
  end
end


class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
