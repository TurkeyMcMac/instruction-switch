class Template
  def initialize(known_areas)
    @known_areas = known_areas
  end

  NONE = Template.new(0)
  ALL = Template.new(~0)

  def known
    @known_areas
  end

  def common(other)
    Template.new(known & other.known)
  end

  def exclude(other)
    Template.new(known ^ other.known)
  end

  def bits
    @known_areas
  end
end
