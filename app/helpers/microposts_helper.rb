module MicropostsHelper

  def delete_link_for(micropost)
    link_to("delete", micropost,
            method: :delete,
            data: { confirm: "You sure?" },
            title: micropost.content )
  end

  def wrap
    sanitize( raw( content.split.map{ |s| wrap_long_string(s) }.join(' ') ))
  end

  def wrap_long_string(text, max_width = 30)
    zero_width_space = "&#8203;"
    regex = /.{1,#{max_width}}/
    ( text.length < max_width ) ? text :
                                  text.scan(regex).join(zero_width_space)
  end
end
