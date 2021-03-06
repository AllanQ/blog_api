# README

JSON API блога

ruby  2.5.0<br/>
rails 5.1.4

сущности:
1. Юзер. Имеет только логин.
2. Пост, принадлежит юзеру. Имеет заголовок, содержание, айпи автора (сохраняется отдельно для каждого поста).
3. Оценка, принадлежит посту. Принимает значение от 1 до 5.

экшены:
1. Создать пост. Принимает заголовок и содержание поста (не могут быть пустыми), а также логин и айпи автора. Если автора с таким логином еще нет, необходимо его создать. Возвращает либо атрибуты поста со статусом 200, либо ошибки валидации со статусом 422.
2. Поставить оценку посту. Принимает айди поста и значение, возвращает новый средний рейтинг поста. Важно: экшен должен корректно отрабатывать при любом количестве конкурентных запросов на оценку одного и того же поста.
3. Получить топ N постов по среднему рейтингу. Просто массив объектов с заголовками и содержанием.
4. Получить список айпи, с которых постило несколько разных авторов. Массив объектов с полями: айпи и массив логинов авторов.

База данных PostgreSQL

development:<br/>
  database: blog_api_development<br/>
  username: blog_api<br/>
  password: blog_api<br/>

test:<br/>
  database: blog_api_test<br/>
  username: blog_api<br/>
  password: blog_api<br/>

production:<br/>
  database: blog_api_production<br/>
  username: blog_api<br/>
  password: blog_api<br/>


Примеры запросов:

1.Создать пост<br/>
curl -H "CONTENT_TYPE: application/vnd.api+JSON" -H "ACCEPT: application/vnd.api+json" -X POST -d '{"title": "Post title", "content": "Some post content", "login": "login", "ip": "127.0.0.1"}' http://0.0.0.0:3000/create

2.Поставить оценку посту<br/>
curl -H "CONTENT_TYPE: application/vnd.api+JSON" -H "ACCEPT: application/vnd.api+json" -X POST -d '{"post_id": 1, "rate": 5}' http://0.0.0.0:3000/rate

3.Получить топ N постов по среднему рейтингу<br/>
curl -H "CONTENT_TYPE: application/vnd.api+JSON" -H "ACCEPT: application/vnd.api+json" -X POST -d '{"top_number": 3}' http://0.0.0.0:3000/top

4.Получить список айпи, с которых постило несколько разных авторов<br/>
curl -H "ACCEPT: application/vnd.api+json" -X GET http://0.0.0.0:3000/popular_ip
