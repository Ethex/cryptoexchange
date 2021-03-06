module Cryptoexchange::Exchanges
  module Wazirx
    module Services
      class Market < Cryptoexchange::Services::Market
        class << self
          def supports_individual_ticker_query?
            false
          end
        end

        def fetch
          output = super(ticker_url)
          adapt_all(output)
        end

        def ticker_url
          "#{Cryptoexchange::Exchanges::Wazirx::Market::API_URL}/tickers"
        end

        def adapt_all(output)
          output.map do |pair|
            market_pair  = Cryptoexchange::Models::MarketPair.new(
              base: pair[1]['base_unit'].upcase,
              target: pair[1]['quote_unit'].upcase,
              market: Wazirx::Market::NAME
            )
            adapt(market_pair, pair[1])
          end
        end

        def adapt(market_pair, output)
          ticker           = Cryptoexchange::Models::Ticker.new
          ticker.base      = market_pair.base
          ticker.target    = market_pair.target
          ticker.market    = Wazirx::Market::NAME
          ticker.last      = NumericHelper.to_d(output['last'].to_f)
          ticker.high      = NumericHelper.to_d(output['high'].to_f)
          ticker.low       = NumericHelper.to_d(output['low'].to_f)
          ticker.bid       = NumericHelper.to_d(output['buy'].to_f)
          ticker.ask       = NumericHelper.to_d(output['sell'].to_f)
          ticker.volume    = NumericHelper.to_d(output['volume'].to_f)
          ticker.timestamp = output['at'].to_i
          ticker.payload   = output
          ticker
        end
      end
    end
  end
end
