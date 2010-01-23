require 'yaml'
class Sign
  @pacchetti = [{"n_pack" => "pacman", "ver" => "1.0", "flag" => true}, {"n_pack" => "lol", "ver" => "1.0", "flag" => true}, {"n_pack" => "shaman", "ver" => "1.0", "flag" => false}]
  def Sign.get_all()              
    return  YAML::load_file("listOnRepo.yaml")
  end
  
  def Sign.check
    @pacchetti[0]["flag"]=false
    return @pacchetti
  end
end
