﻿
Требуется реализовать приоритетную очередь работающую в рамках одного процесса.

Работать она должна следующим образом:

очередь описывается классом Queue

метод Queue#push позволяет добавлять в очередь объекты класса Task, которые характеризуются
    временем до которого его нужно выполнить(finish_time)
    описанием(description)
task = Task.new finish_time: Time.parse('2012-06-25 10:00'), description: 'foo'

метод Queue#get_task(finish_time) возвращает объект класса Task.
  finish_time - время, к которому задание должно быть выполнено, объект класса Time
  один вызов - один объект
  после вызова Queue#get_task - задание удаляется из очереди
  если в очереди есть просроченные задания - сначала нужно вернуть их
  просроченные задания возвращаются по очереди, где сначала идут самые "просроченные" задания
  если в очереди нет "просроченных" заданий, вернуть те, которые должны быть выполнены точно в переданное время.
  Если нет "просроченных" или таких заданий, которые должны быть выполнены точно в переданное время - вернуть nil

метод Queue#pop возвращает объект класса Task.
один вызов - один объект
  после вызова Queue#pop - задание удаляется из очереди
  если в очереди есть просроченные задания - нужно вернуть их
  задания возвращаются по очереди, где сначала идут самые "просроченные" задания
  если нет "просроченных" заданий - вернуть nil

реализуйте эту очередь так, что бы она была threadsafe.
реализуйте эту очередь так, что бы сообщения сохранялись в redis, и методы pop, push, get_task выполнялись атомарно.
