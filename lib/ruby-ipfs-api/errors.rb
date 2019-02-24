module Ipfs
  module Error
    class InvalidDagStream < StandardError
    end

    class InvalidMultihash < StandardError
    end

    class UnreachableDaemon < StandardError
    end
  end
end
