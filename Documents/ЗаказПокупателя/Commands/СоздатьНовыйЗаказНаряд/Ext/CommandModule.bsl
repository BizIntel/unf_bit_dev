﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийЗаказПокупателя.ЗаказНаряд"));
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ОткрытьФорму("Документ.ЗаказПокупателя.ФормаОбъекта", ПараметрыОткрытия);
	
КонецПроцедуры
