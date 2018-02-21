# frozen_string_literal: true

class PostController::PopularIpPost
  SQL_QUERY = <<-HEREDOC
    SELECT *
    FROM (
        SELECT c.ip_address,
               ARRAY_AGG(u.login ORDER BY u.login) AS logins
        FROM connections c
        LEFT JOIN users u
        ON c.user_id = u.id
        GROUP BY c.ip_address)
    AS ip_login_tbl
    WHERE array_length(logins, 1) > 1
    ORDER BY ip_address
  HEREDOC

  def call
    popular_ip = ActiveRecord::Base.connection
                                   .execute(SQL_QUERY)
                                   .to_a
                                   .map do |h|
      { ip_address: h['ip_address'],
        logins: h['logins'][1..-2].split(',') }
    end
    if popular_ip.present?
      Result.new(status: 200, response: popular_ip)
    else
      Result.new(status: 404,
                 response: { popular_ip: ['no poplular ip exists'] })
    end
  end
end
