﻿
&НаКлиенте
Процедура НачалоПериодаДействияПриИзменении(Элемент)
	Объект.НачалоПериодаДействия = НачалоМесяца(Объект.НачалоПериодаДействия);
	Если Объект.КоличествоМесяцев <> 0 Тогда
		Объект.КонецПериодаДействия = 
			КонецМесяца(ДобавитьМесяц(Объект.НачалоПериодаДействия, объект.КоличествоМесяцев - 1));
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура КоличествоМесяцевПриИзменении(Элемент)
	Объект.КонецПериодаДействия = 
			КонецМесяца(ДобавитьМесяц(Объект.НачалоПериодаДействия, объект.КоличествоМесяцев - 1));
КонецПроцедуры
