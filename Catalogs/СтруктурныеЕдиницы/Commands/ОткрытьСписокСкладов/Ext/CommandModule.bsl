﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	МассивОтбора = Новый Массив;
	МассивОтбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыСтруктурныхЕдиниц.Склад"));
	МассивОтбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыСтруктурныхЕдиниц.Розница"));
	МассивОтбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыСтруктурныхЕдиниц.РозницаСуммовойУчет"));
	
	СтруктураОтбора = Новый Структура("ТипСтруктурнойЕдиницы", МассивОтбора);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", СтруктураОтбора);
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", "Склады");
	
	ОткрытьФорму("Справочник.СтруктурныеЕдиницы.ФормаСписка",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка
	);
	
КонецПроцедуры
