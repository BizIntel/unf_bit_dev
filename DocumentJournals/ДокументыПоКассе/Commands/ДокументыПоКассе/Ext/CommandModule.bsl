﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ЖурналДокументыПоКассе");
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
	ПараметрыОткрытия = Новый Структура("ЭтоНачальнаяСтраница", Ложь);	
	ОткрытьФорму("ЖурналДокументов.ДокументыПоКассе.ФормаСписка", ПараметрыОткрытия, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
