class CardFinder
  @@cards = {
      wind: {
        #                  cost,power           cost,power
          '1' => [[:wind, 1, 2, 1, :l], [:wind, 1, 8, 4, :xl]],
          '2' => [[:wind, 2, 5, 3, :xl], [:wind, 2, 10, 6, :xl]],
          '3' => [[:wind, 3, 8, 6, :xl], [:wind, 3, 12, 9, :xl]],
          '4' => [[:wind, 4, 10, 10, :xl], [:wind, 4, 14, 14, :xl]]
      },
      solar: {
          '1' => [[:solar, 1, 4, 1, :xs], [:solar, 1, 16, 4, :xs]],
          '2' => [[:solar, 2, 10, 3, :xs], [:solar, 2, 20, 6, :xs]],
          '3' => [[:solar, 3, 16, 6, :xs], [:solar, 3, 24, 9, :xs]],
          '4' => [[:solar, 4, 20, 10, :s], [:solar, 4, 28, 14, :s]]
      },
      geo: {
          '1' => [[:geo, 1, 2, 1, :xs], [:geo, 1, 8, 4, :s]],
          '2' => [[:geo, 2, 5, 3, :s], [:geo, 2, 10, 6, :m]],
          '3' => [[:geo, 3, 4, 3, :s], [:geo, 3, 8, 6, :m]],
          '4' => [[:geo, 4, 3, 3, :s], [:geo, 4, 6, 6, :m]]
      },
      hydro: {
          '1' => [[:hydro, 1, 3, 1, :s], [:hydro, 1, 12, 4, :m]],
          '2' => [[:hydro, 2, 10, 4, :m], [:hydro, 2, 15, 6, :l]],
          '3' => [[:hydro, 3, 16, 8, :xl], [:hydro, 3, 24, 12, :xl]],
          '4' => [[:hydro, 4, 24, 16, :xl], [:hydro, 4, 36, 24, :xl]]
      },
      nuclear: {
          '1' => [[:nuclear, 1, 8, 8, :m], [:nuclear, 1, 16, 16, :l]],
          '2' => [[:nuclear, 2, 10, 12, :l], [:nuclear, 2, 15, 18, :xl]],
          '3' => [[:nuclear, 3, 10, 15, :xl], [:nuclear, 3, 14, 21, :xl]],
          '4' => [[:nuclear, 4, 12, 24, :xl], [:nuclear, 4, 24, 48, :xl]]
      }
  }
  class << self
    def find(family, tier, version = 0)
      tier = 4 if tier > 4
      x = @@cards[family][tier.to_s][version]
      return Card.new(*x)
    end
  end
end

class CardDeck
  def initialize
    @cards = populate
    @cards.shuffle!
    @cards.shuffle!
  end

  protected

  def populate
    cards = []
    quantities = {
        wind: {
            '1' => [9, 6],
            '2' => [9, 6],
            '3' => [9, 6],
            '4' => [9, 6],
        },
        solar: {
            '1' => [9, 6],
            '2' => [9, 6],
            '3' => [9, 6],
            '4' => [9, 6],
        },
        geo: {
            '1' => [9, 6],
            '2' => [9, 6],
            '3' => [9, 6],
            '4' => [9, 6],
        },
        hydro: {
            '1' => [9, 6],
            '2' => [9, 6],
            '3' => [9, 6],
            '4' => [9, 6],
        },
        nuclear: {
            '1' => [3, 3],
            '2' => [3, 3],
            '3' => [3, 3],
            '4' => [3, 3],
        }
    }
    quantities.each_pair do |family, tiers|
      tiers.each_pair do |tier, counts|
        tier = tier.to_i
        counts[0].times do
          cards << CardFinder.find(family, tier, 0)
        end
        counts[1].times do
          cards << CardFinder.find(family, tier, 1)
        end
      end
    end

    cards
  end
end