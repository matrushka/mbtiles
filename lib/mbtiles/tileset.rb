require "sequel"

class MBTiles::Tileset
  REQUIRED_METADATA_KEYS = [:name, :type, :version, :description, :format]

  REQUIRED_METADATA_KEYS.each do |key|
    define_method(key) { metadata[key] }
  end

  def initialize(path)
    @path = path.is_a?(Pathname) ? path : Pathname.new(path.to_s)
  end

  def metadata
    @metadata ||= database[:metadata].to_hash(:name, :value).symbolize_keys
  end

  def tile_at(x, y, z)
    database[:tiles].where(tile_column: x, tile_row: y, zoom_level: z).first
  end

  def load!
    database && self
  end

  def loaded?
    @database.present?
  end

  def database
    @database ||= Sequel.sqlite(@path.realpath.to_s)
  end
end
