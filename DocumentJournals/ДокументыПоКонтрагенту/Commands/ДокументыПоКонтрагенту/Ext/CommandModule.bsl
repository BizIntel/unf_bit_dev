﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ЖурналДокументыПоКонтрагенту");
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Контрагент", ПараметрКоманды);
	
	ОткрытьФорму("ЖурналДокументов.ДокументыПоКонтрагенту.Форма.ФормаСписка",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры
