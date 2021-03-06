﻿Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Узел = ОбменСКассовымСерверомШтрихМПовтИсп.УзелОбменаШтрих();
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		Если НЕ ЗначениеЗаполнено(Запись.ИдентификаторОбластиНаСервереШтрихМ) Тогда
			Запись.ИдентификаторОбластиНаСервереШтрихМ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Узел, "ИдентификаторОбластиНаСервереШтрихМ");
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Запись.РегистрационныйНомер) Тогда
			Сообщение = НСтр("ru = 'Введите регистрационный номер.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение, ЭтотОбъект, "РегистрационныйНомер",, Отказ);
			Возврат;
		КонецЕсли;
		
		Попытка
			Запись.РегистрационныйНомер = Формат(Число(СокрЛП(Запись.РегистрационныйНомер)), "ЧГ=");
		Исключение
			КлючДанных = РегистрыСведений.НастройкиКассыШтрихМ.СоздатьКлючЗаписи(Новый Структура("КассаККМ", Запись.КассаККМ));
			Сообщение = СтрШаблон(НСтр("ru = 'Регистрационный номер: %1 не корректен.'"), Запись.РегистрационныйНомер);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение, КлючДанных, "РегистрационныйНомер",, Отказ);
			Возврат;
		КонецПопытки;

		
		ПроверитьРегистрационныйНомер(Запись.РегистрационныйНомер, Запись.КассаККМ, Отказ);
		
		Если Отказ Тогда
			КлючДанных = РегистрыСведений.НастройкиКассыШтрихМ.СоздатьКлючЗаписи(Новый Структура("КассаККМ", Запись.КассаККМ));
			Сообщение = СтрШаблон(НСтр("ru = 'Регистрационный номер: %1 уже используется.'"), Запись.РегистрационныйНомер);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение, КлючДанных, "РегистрационныйНомер",, Отказ);
			Возврат;
		КонецЕсли;
		
		

		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьРегистрационныйНомер(НовыйРегистрационныйНомер, СсылкаНаОбъект, Отказ)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	КассовыеАппараты.КассаККМ
	|ИЗ
	|	РегистрСведений.НастройкиКассыШтрихМ КАК КассовыеАппараты
	|ГДЕ
	|	НЕ КассовыеАппараты.КассаККМ = &СсылкаНаОбъект
	|	И КассовыеАппараты.РегистрационныйНомер = &РегистрационныйНомер");
	
	Запрос.УстановитьПараметр("СсылкаНаОбъект", СсылкаНаОбъект);
	Запрос.УстановитьПараметр("РегистрационныйНомер", НовыйРегистрационныйНомер);
	
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры
