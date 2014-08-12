module MicropostsHelper

  def delete_link_for(micropost)
    link_to("delete", micropost,
            method: :delete,
            data: { confirm: "You sure?" },
            title: micropost.content )
  end

end
