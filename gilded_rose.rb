MINIMUM_QUALITY = 0
MAXIMUM_QUALITY = 50
AGED_BRIE = "Aged Brie"
BACKSTAGE_PASSES = "Backstage passes to a TAFKAL80ETC concert"
SULFURAS = "Sulfuras, Hand of Ragnaros"

def increase_item_quality(item, amount = 1)
  return unless item.quality < 50

  item.quality += amount
end

def decrease_item_quality(item)
  if item.quality > MINIMUM_QUALITY
    item.quality -= 1
  end
end

def sell_by_date_passed?(item)
  item.sell_in < 0
end

def reduce_sell_by_date(item)
  item.sell_in -= 1
end

def update_item_quality(item)
  return decrease_item_quality(item) unless [BACKSTAGE_PASSES, AGED_BRIE].include? item.name

  if item.quality < MAXIMUM_QUALITY
    item.quality += 1
    if item.name == BACKSTAGE_PASSES
      if item.sell_in < 6
        increase_item_quality(item, 2)
      elsif item.sell_in < 11
        increase_item_quality(item)
      end
    end
  end
end

def handle_sell_by_date_passed(item)
  return unless sell_by_date_passed?(item)

  return increase_item_quality(item) if item.name == AGED_BRIE
  return item.quality = 0 if item.name == BACKSTAGE_PASSES

  decrease_item_quality(item)
end

def update_quality(items)
  items.each do |item|
    skip if item.name == SULFURAS

    update_item_quality(item)

    reduce_sell_by_date(item)

    handle_sell_by_date_passed(item)
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

