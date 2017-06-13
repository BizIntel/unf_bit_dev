﻿#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьРегионы(Регионы) Экспорт 
	РегламентированнаяОтчетность.ЗаполнитьРегионы(Регионы);
КонецПроцедуры

Процедура СформироватьАдрес(КонтактнаяИнформация, РоссийскийАдрес) Экспорт
	ЗначенияПолей = УправлениеКонтактнойИнформацией.ПредыдущийФорматКонтактнойИнформацииXML(КонтактнаяИнформация);
	
	Для Каждого Элемент Из РоссийскийАдрес Цикл
		РоссийскийАдрес[Элемент.Ключ] = "";
	КонецЦикла;
	
	Для НомСтр = 1 По СтрЧислоСтрок(ЗначенияПолей) Цикл
		Стр = СтрПолучитьСтроку(ЗначенияПолей, НомСтр);
		
		ПредставлениеСтр = Лев(Стр, СтрНайти(Стр, "=") - 1);
		ЗначениеСтр = Сред(Стр, СтрНайти(Стр, "=") + 1);
		
		Если ТипЗнч(РоссийскийАдрес) = Тип("Соответствие") И ЗначениеЗаполнено(ПредставлениеСтр) И НЕ РоссийскийАдрес.Получить(ПредставлениеСтр) = Неопределено Тогда
			РоссийскийАдрес[ПредставлениеСтр] = ЗначениеСтр;
		ИначеЕсли ТипЗнч(РоссийскийАдрес) = Тип("Структура") И ЗначениеЗаполнено(ПредставлениеСтр) И РоссийскийАдрес.Свойство(ПредставлениеСтр) Тогда
			РоссийскийАдрес[ПредставлениеСтр] = ЗначениеСтр;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти