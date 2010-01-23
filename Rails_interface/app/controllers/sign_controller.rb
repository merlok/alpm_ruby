class SignController < ApplicationController 
  # GET /signs
  # GET /signs.xml
  
  
  def index
    @signs = Sign.get_all
=begin
    @b.values.each do |param|
      @signs.each do |all_p|
        if all_p["n_pack"]==param
          all_p["flag"]=true
        end
        if all_p["n_pack"]!=param
          all_p["flag"]=false
        end
      end
    end
=end
    respond_to do |format|
      format.html # index.html.erb
      format.hash { render :hash => @signs }
    end
  end
 
  def up_div
    @b = request.parameters    
    @b.delete("commit")
    @b.delete("authenticity_token")
    @b.delete("action")
    @b.delete("controller")
    render :partial => "sign", :locals => {:signs => Sign.check, :metodi => @b}
 

  end
end
