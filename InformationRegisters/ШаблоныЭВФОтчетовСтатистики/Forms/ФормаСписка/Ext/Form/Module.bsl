﻿
#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Загрузить(Команда)
	
	ДобавитьШаблоны();
	
КонецПроцедуры

#Если НЕ ВебКлиент Тогда

&НаКлиенте
Процедура ДобавитьШаблоныНаТонкомКлиенте()
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.Заголовок = "Выберите XML-шаблоны";
	ДиалогВыбораФайла.МножественныйВыбор =  Истина;
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла = Истина;
	ДиалогВыбораФайла.Расширение = "xml";
	ДиалогВыбораФайла.Фильтр = "Файлы XML-шаблонов ЭВФ статистики (*.xml)|*.xml";
	Если НЕ ДиалогВыбораФайла.Выбрать() Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоФайлов = ДиалогВыбораФайла.ВыбранныеФайлы.Количество();
	
	ВыбранныеФайлы = ДиалогВыбораФайла.ВыбранныеФайлы;
	
	РежимОдногоФайла = (КоличествоФайлов = 1);
	
	ОбъектыФайл = Новый Массив;
	КороткиеИменаФайлов = Новый Массив;
	Для Каждого ВыбранныйФайл Из ВыбранныеФайлы Цикл
		ОбъектФайл = Новый Файл(ВыбранныйФайл);
		ОбъектыФайл.Добавить(ОбъектФайл);
		КороткиеИменаФайлов.Добавить(ОбъектФайл.Имя);
	КонецЦикла;
	
	Если ХотяБыОдинШаблонПрисутствуетВИБ(КороткиеИменаФайлов) Тогда
		Если РежимОдногоФайла Тогда
			ТекстВопроса = "XML-шаблон с аналогичным именем уже загружен в информационную базу.
				|Заменить существующий XML-шаблон?";
		Иначе
			ТекстВопроса = "Некоторые из выбранных XML-шаблонов уже присутствуют в информационной базе.
				|Продолжить загрузку с заменой XML-шаблонов в информационной базе на XML-шаблоны с диска?";
		КонецЕсли;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьШаблоныНаТонкомКлиентеЗавершение", ЭтотОбъект, Новый Структура("КоличествоФайлов, ОбъектыФайл, РежимОдногоФайла", КоличествоФайлов, ОбъектыФайл, РежимОдногоФайла));
		ПоказатьВопрос(ОписаниеОповещения, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1'"), ТекстВопроса), РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаписатьШаблоныНаТонкомКлиенте(КоличествоФайлов, ОбъектыФайл, РежимОдногоФайла);
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьШаблоныНаТонкомКлиентеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	КоличествоФайлов = ДополнительныеПараметры.КоличествоФайлов;
	ОбъектыФайл = ДополнительныеПараметры.ОбъектыФайл;
	РежимОдногоФайла = ДополнительныеПараметры.РежимОдногоФайла;
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаписатьШаблоныНаТонкомКлиенте(КоличествоФайлов, ОбъектыФайл, РежимОдногоФайла);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьШаблоныНаТонкомКлиенте(КоличествоФайлов, ОбъектыФайл, РежимОдногоФайла)
	
	КоличествоНезагруженныхШаблонов = 0;
	
	ШаблоныЭВФ = Новый Массив;
	
	НеЗагруженныеШаблоны = Новый Массив;
	Для Каждого ОбъектФайл Из ОбъектыФайл Цикл
		
		Если ОбъектФайл.Существует() Тогда
			
			Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Загрузка XML-шаблона ""%1""...'"), ОбъектФайл.Имя), , , БиблиотекаКартинок.ЗагрузкаФайла);
			
			ШаблонЭВФ = Новый Структура;
			ШаблонЭВФ.Вставить("ИмяФайлаШаблона", НРег(ОбъектФайл.Имя));
			ШаблонЭВФ.Вставить("Размер", ОбъектФайл.Размер());
			
			Попытка
				
				ШаблонЭВФ.Вставить("Шаблон", Новый ДвоичныеДанные(ОбъектФайл.ПолноеИмя));
				
				ШаблоныЭВФ.Добавить(ШаблонЭВФ);
				
			Исключение
				
				Если РежимОдногоФайла тогда
					ПоказатьПредупреждение(,СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не удалось загрузить XML-шаблон ""%1"":%2'"), ОбъектФайл.Имя, ОписаниеОшибки()));
					Возврат;
				Иначе
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не удалось загрузить XML-шаблон ""%1"":%2'"), ОбъектФайл.Имя, Символы.ПС + Символы.ПС + ОписаниеОшибки());
					НеЗагруженныеШаблоны.Добавить(ТекстСообщения);
				КонецЕсли;
				
				КоличествоНезагруженныхШаблонов = КоличествоНезагруженныхШаблонов + 1;
				
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого ТекстСообщения Из НеЗагруженныеШаблоны Цикл
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ТекстСообщения;
		Сообщение.Сообщить();
	КонецЦикла;
	
	Состояние(НСтр("ru='Запись XML-шаблонов...'"), , , БиблиотекаКартинок.Записать);
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(ШаблоныЭВФ, Новый УникальныйИдентификатор);
	ЗагрузитьШаблоны(АдресВременногоХранилища, КоличествоНезагруженныхШаблонов);
	ПоказатьПредупрежденияПослеЗагрузкиШаблонов(КоличествоНезагруженныхШаблонов, КоличествоФайлов, РежимОдногоФайла);
	
КонецПроцедуры

#Иначе

&НаКлиенте
Процедура ДобавитьШаблоныВВебКлиенте()
	
	АдресФайлаВоВременномХранилище = "";
	ВыбранноеИмяФайла              = "";
	
	ДополнительныеПараметры = Новый Структура("АдресФайлаВоВременномХранилище, ВыбранноеИмяФайла", АдресФайлаВоВременномХранилище, ВыбранноеИмяФайла);
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьШаблоныНаВебКлиентеПоместитьФайлЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПомещениеФайла(ОписаниеОповещения, АдресФайлаВоВременномХранилище, , , УникальныйИдентификатор);

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьШаблоныНаВебКлиентеПоместитьФайлЗавершение(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	АдресФайлаВоВременномХранилище = Адрес;
	
	Если НЕ Результат Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоФайлов = 1;
	
	ВыбранныеФайлы = Новый Массив();
	ВыбранныеФайлы.Добавить(ВыбранноеИмяФайла);
	
	РежимОдногоФайла = (КоличествоФайлов = 1);
	
	ОбъектыФайл = Новый Массив;
	КороткиеИменаФайлов = Новый Массив;
	Для Каждого ВыбранныйФайл Из ВыбранныеФайлы Цикл
		ОбъектФайл = Новый Файл(ВыбранныйФайл);
		ОбъектыФайл.Добавить(ОбъектФайл);
		КороткиеИменаФайлов.Добавить(ОбъектФайл.Имя);
	КонецЦикла;
	
	Если НЕ ОбъектФайл.Расширение = ".xml" Тогда
		ПоказатьПредупреждение(,НСтр("ru='Выбранный файл не является XML-шаблоном электронной версии формы отчета статистики.'"));
		Возврат;
	КонецЕсли;
	
	Если ХотяБыОдинШаблонПрисутствуетВИБ(КороткиеИменаФайлов) Тогда
		Если РежимОдногоФайла Тогда
			ТекстВопроса = "XML-шаблон с аналогичным именем уже загружен в информационную базу.
				|Заменить существующий XML-шаблон?";
		Иначе
			ТекстВопроса = "Некоторые из выбранных XML-шаблонов уже присутствуют в информационной базе.
				|Продолжить загрузку с заменой XML-шаблонов в информационной базе на XML-шаблоны с диска?";
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура("АдресФайлаВоВременномХранилище, КоличествоФайлов, ОбъектФайл, РежимОдногоФайла", АдресФайлаВоВременномХранилище, КоличествоФайлов, ОбъектФайл, РежимОдногоФайла);
		ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьШаблоныНаВебКлиентеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1'"), ТекстВопроса), РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаписатьШаблоныВВебКлиенте(АдресФайлаВоВременномХранилище, КоличествоФайлов, ОбъектФайл, РежимОдногоФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьШаблоныНаВебКлиентеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	АдресФайлаВоВременномХранилище = ДополнительныеПараметры.АдресФайлаВоВременномХранилище;
	КоличествоФайлов = ДополнительныеПараметры.КоличествоФайлов;
	ОбъектФайл = ДополнительныеПараметры.ОбъектФайл;
	РежимОдногоФайла = ДополнительныеПараметры.РежимОдногоФайла;
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаписатьШаблоныВВебКлиенте(АдресФайлаВоВременномХранилище, КоличествоФайлов, ОбъектФайл, РежимОдногоФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьШаблоныВВебКлиенте(АдресФайлаВоВременномХранилище, Знач КоличествоФайлов, Знач ОбъектФайл, Знач РежимОдногоФайла)
	
	КоличествоНезагруженныхШаблонов = 0;
	Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Загрузка XML-шаблона ""%1""...'"), ОбъектФайл.Имя), , , БиблиотекаКартинок.ЗагрузкаФайла);
	Если НЕ ЗагрузитьШаблон(АдресФайлаВоВременномХранилище, ОбъектФайл.Имя, КоличествоНезагруженныхШаблонов) Тогда
		ПоказатьПредупреждение(,СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не удалось загрузить XML-шаблон ""%1"":%2'"), ОбъектФайл.Имя, ОписаниеОшибки()));
		Возврат;
	КонецЕсли;
	ПоказатьПредупрежденияПослеЗагрузкиШаблонов(КоличествоНезагруженныхШаблонов, КоличествоФайлов, РежимОдногоФайла);

КонецПроцедуры

#КонецЕсли

&НаКлиенте
Процедура ДобавитьШаблоны()
	
	#Если НЕ ВебКлиент Тогда
		ДобавитьШаблоныНаТонкомКлиенте();
	#Иначе
		ДобавитьШаблоныВВебКлиенте();
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПредупрежденияПослеЗагрузкиШаблонов(КоличествоНезагруженныхШаблонов, КоличествоФайлов, РежимОдногоФайла)
	
	Если КоличествоНезагруженныхШаблонов = КоличествоФайлов Тогда
		ПоказатьПредупреждение(,НСтр("ru='Не удалось загрузить ни один из указанных XML-шаблонов.'"));
	Иначе
		Если РежимОдногоФайла Тогда
			ТекстПредупреждения = "XML-шаблон успешно загружен.";
		ИначеЕсли КоличествоНезагруженныхШаблонов = 0 Тогда
			ТекстПредупреждения = "Все XML-шаблоны успешно загружены.";
		Иначе
			ТекстПредупреждения = "Загружены " + (КоличествоФайлов - КоличествоНезагруженныхШаблонов) + " из " + КоличествоФайлов + " XML-шаблонов.
			|Остальные XML-шаблоны загрузить на удалось.";
		КонецЕсли;
		ПоказатьПредупреждение(,СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1'"), ТекстПредупреждения));
		Оповестить("ИзменениеДанныхРегистраШаблоныЭВФОтчетовСтатистики");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьШаблоны(Команда)
	
	ОбновитьШаблоныИзКонфигурации();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьШаблоныИзКонфигурации(Интерактивно = Истина) Экспорт
	
	Перем АдресВременногоХранилища;
	Перем КороткиеИменаФайлов;
	
	КоличествоНезагруженныхШаблонов = 0;
	
	Попытка
	
		ДобавитьШаблоныИзКонфигурации(АдресВременногоХранилища, КороткиеИменаФайлов, КоличествоНезагруженныхШаблонов);
	
	Исключение
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ОписаниеОшибки();
		Сообщение.Сообщить();
		
		Возврат;
		
	КонецПопытки;
	
	КоличествоФайлов = КороткиеИменаФайлов.Количество();
	РежимОдногоФайла = (КоличествоФайлов = 1);
	
	Если Интерактивно И ХотяБыОдинШаблонПрисутствуетВИБ(КороткиеИменаФайлов) Тогда
		
		Если РежимОдногоФайла Тогда
			ТекстВопроса = "XML-шаблон с аналогичным именем уже загружен в информационную базу.
							|Заменить существующий XML-шаблон?";
		Иначе
			ТекстВопроса = "Некоторые из выбранных XML-шаблонов уже присутствуют в информационной базе.
							|Продолжить загрузку с заменой XML-шаблонов в информационной базе на XML-шаблоны из конфигурации (если версия шаблона выше текущей)?";
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура("АдресВременногоХранилища, Интерактивно, КоличествоНезагруженныхШаблонов, КоличествоФайлов, РежимОдногоФайла", АдресВременногоХранилища, Интерактивно, КоличествоНезагруженныхШаблонов, КоличествоФайлов, РежимОдногоФайла);
		ОписаниеОповещения = Новый ОписаниеОповещения("ВопросЗаменитьШаблоныЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1'"), ТекстВопроса), РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗагрузитьШаблоныИзКонфигурации(АдресВременногоХранилища, Интерактивно, КоличествоНезагруженныхШаблонов, КоличествоФайлов, РежимОдногоФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗаменитьШаблоныЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	АдресВременногоХранилища = ДополнительныеПараметры.АдресВременногоХранилища;
	Интерактивно = ДополнительныеПараметры.Интерактивно;
	КоличествоНезагруженныхШаблонов = ДополнительныеПараметры.КоличествоНезагруженныхШаблонов;
	КоличествоФайлов = ДополнительныеПараметры.КоличествоФайлов;
	РежимОдногоФайла = ДополнительныеПараметры.РежимОдногоФайла;
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗагрузитьШаблоныИзКонфигурации(АдресВременногоХранилища, Интерактивно, КоличествоНезагруженныхШаблонов, КоличествоФайлов, РежимОдногоФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьШаблоныИзКонфигурации(АдресВременногоХранилища, Интерактивно, КоличествоНезагруженныхШаблонов, КоличествоФайлов, РежимОдногоФайла)
	
	Состояние(НСтр("ru='Запись XML-шаблонов...'"), , , БиблиотекаКартинок.Записать);
	
	ЗагрузитьШаблоны(АдресВременногоХранилища, КоличествоНезагруженныхШаблонов);
	
	Если Интерактивно Тогда
		Если КоличествоНезагруженныхШаблонов = КоличествоФайлов Тогда
			ПоказатьПредупреждение(,НСтр("ru='Не удалось загрузить ни один из указанных XML-шаблонов.'"));
			Возврат;
		Иначе
			Если РежимОдногоФайла Тогда
				ТекстПредупреждения = "XML-шаблон успешно загружен.";
			ИначеЕсли КоличествоНезагруженныхШаблонов = 0 Тогда
				ТекстПредупреждения = "Все XML-шаблоны успешно загружены.";
			Иначе
				ТекстПредупреждения = "Загружены " + (КоличествоФайлов - КоличествоНезагруженныхШаблонов) + " из " + КоличествоФайлов + " XML-шаблонов.
				|Остальные XML-шаблоны загрузить на удалось.";
			КонецЕсли;
			ОписаниеОповещения = Новый ОписаниеОповещения("ОбновитьШаблоныИзКонфигурацииЗавершение", ЭтотОбъект);
			ПоказатьПредупреждение(ОписаниеОповещения, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1'"), ТекстПредупреждения));
			
		КонецЕсли;
	Иначе
		Состояние();
		
		Оповестить("ИзменениеДанныхРегистраШаблоныЭВФОтчетовСтатистики");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьШаблоныИзКонфигурацииЗавершение(ДополнительныеПараметры) Экспорт
	
	Состояние();
	Оповестить("ИзменениеДанныхРегистраШаблоныЭВФОтчетовСтатистики");

КонецПроцедуры

&НаСервере
Процедура ДобавитьШаблоныИзКонфигурации(АдресВременногоХранилища, КороткиеИменаФайлов, КоличествоНезагруженныхШаблонов)
	
	ВремФайлАрхиваШаблонов = ПолучитьИмяВременногоФайла("zip");
	АрхивШаблоновЭВФДвоичныеДанные = РегистрыСведений.ШаблоныЭВФОтчетовСтатистики.ПолучитьМакет("ШаблоныЭВФ");
	Попытка
		АрхивШаблоновЭВФДвоичныеДанные.Записать(ВремФайлАрхиваШаблонов);
	Исключение
		ВызватьИсключение "Не удалось сохранить архив шаблонов ЭВФ во временный файл." + Символы.ПС + ОписаниеОшибки();
	КонецПопытки;
	
	КаталогВремФайлов = КаталогВременныхФайлов();
	КаталогВремФайлов = ?(Прав(КаталогВремФайлов, 1) = "\", КаталогВремФайлов, КаталогВремФайлов + "\");
	ВремКаталог = КаталогВремФайлов + Строка(Новый УникальныйИдентификатор) + "\";
	
	Попытка
		ЗИП = Новый ЧтениеZipФайла(ВремФайлАрхиваШаблонов);
		ЗИП.ИзвлечьВсе(ВремКаталог, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
		ЗИП.Закрыть();
	Исключение
		ВызватьИсключение "Не удалось распаковать архив шаблонов ЭВФ.
				|" + ИнформацияОбОшибке().Описание;
		Возврат;
	КонецПопытки;
	
	ОбъектыФайл = НайтиФайлы(ВремКаталог, "*.xml", Ложь);
	
	КороткиеИменаФайлов = Новый Массив;
	
	ШаблоныЭВФ = Новый Массив;
	
	Для Каждого ОбъектФайл Из ОбъектыФайл Цикл
		
		Если ОбъектФайл.Существует() Тогда
			
			ШаблонЭВФ = Новый Структура;
			ШаблонЭВФ.Вставить("ИмяФайлаШаблона", НРег(ОбъектФайл.Имя));
			ШаблонЭВФ.Вставить("Размер", ОбъектФайл.Размер());
			
			Попытка
				
				ШаблонЭВФ.Вставить("Шаблон", Новый ДвоичныеДанные(ОбъектФайл.ПолноеИмя));
				ШаблоныЭВФ.Добавить(ШаблонЭВФ);
				
				КороткиеИменаФайлов.Добавить(ОбъектФайл.Имя);
				
			Исключение
				
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не удалось загрузить XML-шаблон ""%1"":%2'"), ОбъектФайл.Имя, Символы.ПС + ОписаниеОшибки());
				Сообщение.Сообщить();
				
				КоличествоНезагруженныхШаблонов = КоличествоНезагруженныхШаблонов + 1;
				
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЦикла;
	
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(ШаблоныЭВФ, Новый УникальныйИдентификатор);
	
	УдалитьФайлы(ВремФайлАрхиваШаблонов);
	Попытка
		УдалитьФайлы(ВремКаталог);
	Исключение
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Функция ХотяБыОдинШаблонПрисутствуетВИБ(КороткиеИменаФайлов)
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	ШаблоныЭВФОтчетовСтатистики.ИмяФайлаШаблона
	                      |ИЗ
	                      |	РегистрСведений.ШаблоныЭВФОтчетовСтатистики КАК ШаблоныЭВФОтчетовСтатистики
	                      |ГДЕ
	                      |	ШаблоныЭВФОтчетовСтатистики.ИмяФайлаШаблона В(&ВыбранныеФайлы)
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	ШаблоныЭВФОтчетовСтатистики.ИмяФайлаШаблона");
	Запрос.УстановитьПараметр("ВыбранныеФайлы", КороткиеИменаФайлов);
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

&НаСервере
Функция ЗагрузитьШаблон(АдресФайлаВоВременномХранилище, ИмяФайлаШаблона, КоличествоНезагруженныхШаблонов)
	
	ШаблоныЭВФ = Новый Массив;
	
	ФайлШаблона = ПолучитьИзВременногоХранилища(АдресФайлаВоВременномХранилище);
	
	Если НЕ ФайлШаблона = Неопределено Тогда
		
		ШаблонЭВФ = Новый Структура;
		ШаблонЭВФ.Вставить("ИмяФайлаШаблона", НРег(ИмяФайлаШаблона));
		
		Попытка
			
			ШаблонЭВФ.Вставить("Шаблон", ФайлШаблона);
			ШаблонЭВФ.Вставить("Размер", ФайлШаблона.Размер());
			
			ШаблоныЭВФ.Добавить(ШаблонЭВФ);
			
		Исключение
			
			Возврат Ложь;
			
		КонецПопытки;
		
	КонецЕсли;
	
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(ШаблоныЭВФ, Новый УникальныйИдентификатор);
	
	ЗагрузитьШаблоны(АдресВременногоХранилища, КоличествоНезагруженныхШаблонов);
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьШаблоны(АдресВременногоХранилища, КоличествоНезагруженныхШаблонов)
	
	ШаблоныЭВФ = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	
	Для Каждого ШаблонЭВФ Из ШаблоныЭВФ Цикл
		
		Если НЕ ДобавитьРеквизитыИзФайлаШаблона(ШаблонЭВФ) Тогда
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не распознан формат XML-шаблона ""%1""'"), ШаблонЭВФ.ИмяФайлаШаблона);
			Сообщение.Сообщить();
			
			КоличествоНезагруженныхШаблонов = КоличествоНезагруженныхШаблонов + 1;
			
			Продолжить;
			
		КонецЕсли;
		
		Если СтрНайти(ШаблонЭВФ.ВерсияФормата, "1.3") = 0 Тогда
		
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Версия формата XML-шаблона ""%1"" не соответствует версии ""1.3""'"), ШаблонЭВФ.ИмяФайлаШаблона);
			Сообщение.Сообщить();
			
			КоличествоНезагруженныхШаблонов = КоличествоНезагруженныхШаблонов + 1;
			
			Продолжить;
		
		КонецЕсли;
		
		МенеджерЗаписи = РегистрыСведений.ШаблоныЭВФОтчетовСтатистики.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ИмяФайлаШаблона  = ШаблонЭВФ.ИмяФайлаШаблона;
		МенеджерЗаписи.Прочитать();
		Если МенеджерЗаписи.Выбран() Тогда
			Если ДатаВерсии(МенеджерЗаписи.Версия) > ДатаВерсии(ШаблонЭВФ.Версия) Тогда
				
				КоличествоНезагруженныхШаблонов = КоличествоНезагруженныхШаблонов + 1;
				
				Продолжить;
				
			КонецЕсли;
		КонецЕсли;
		
		МенеджерЗаписи.ИмяФайлаШаблона  = ШаблонЭВФ.ИмяФайлаШаблона;
		
		МенеджерЗаписи.ОКУД             = ШаблонЭВФ.ОКУД;
		МенеджерЗаписи.КодШаблона       = ШаблонЭВФ.КодШаблона;
		МенеджерЗаписи.Наименование     = ШаблонЭВФ.Наименование;
		МенеджерЗаписи.КодПериодичности = ШаблонЭВФ.КодПериодичности;
		МенеджерЗаписи.КодФормы         = ШаблонЭВФ.КодФормы;
		МенеджерЗаписи.Шифр             = ШаблонЭВФ.Шифр;
		МенеджерЗаписи.Версия           = ШаблонЭВФ.Версия;
		
		МенеджерЗаписи.Размер           = ШаблонЭВФ.Размер;
		МенеджерЗаписи.ДатаДобавления   = ТекущаяДатаСеанса();
		
		Попытка
			
			МенеджерЗаписи.Шаблон = Новый ХранилищеЗначения(ШаблонЭВФ.Шаблон, Новый СжатиеДанных(8));
			МенеджерЗаписи.Записать(Истина);
			
		Исключение
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не удалось записать XML-шаблон ""%1"":%2'"), ШаблонЭВФ.ИмяФайлаШаблона, Символы.ПС + ОписаниеОшибки());
			Сообщение.Сообщить();
			
			КоличествоНезагруженныхШаблонов = КоличествоНезагруженныхШаблонов + 1;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДобавитьРеквизитыИзФайлаШаблона(РеквизитыШаблона)
	
	Если ТипЗнч(РеквизитыШаблона) <> Тип("Структура") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ВремФайлШаблона = ПолучитьИмяВременногоФайла("." + РеквизитыШаблона.ИмяФайлаШаблона);
	
	Попытка
		РеквизитыШаблона.Шаблон.Записать(ВремФайлШаблона);
	Исключение
		Возврат Ложь;
	КонецПопытки;

	АтрибутыШаблона = Новый Соответствие;
	ОбъектЧтениеXML = Новый ЧтениеXML;
	
	Попытка
		
		ОбъектЧтениеXML.ОткрытьФайл(ВремФайлШаблона);
		ОбъектЧтениеXML.ИгнорироватьПробелы = Ложь;
		
		Пока ОбъектЧтениеXML.Прочитать() Цикл
			Если ОбъектЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
				Если НРег(ОбъектЧтениеXML.Имя) = "metaform" Тогда
					Пока ОбъектЧтениеXML.ПрочитатьАтрибут() Цикл
						Если АтрибутыШаблона[ОбъектЧтениеXML.Имя] = Неопределено Тогда
							АтрибутыШаблона.Вставить(СтрЗаменить(ОбъектЧтениеXML.Имя, "-", "_"), ОбъектЧтениеXML.Значение);
						КонецЕсли;
					КонецЦикла;
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		ОбъектЧтениеXML.Закрыть();
		
	Исключение
		
		Возврат Ложь;
		
	КонецПопытки;
	
	УдалитьФайлы(ВремФайлШаблона);
	
	Если АтрибутыШаблона.Количество() = 0 Тогда
	
		Возврат Ложь;
	
	КонецЕсли;
	
	РеквизитыШаблона.Вставить("ОКУД",             АтрибутыШаблона["OKUD"]);
	РеквизитыШаблона.Вставить("КодШаблона",       АтрибутыШаблона["code"]);
	РеквизитыШаблона.Вставить("Наименование",     ВРег(Лев(АтрибутыШаблона["name"], 1)) + Сред(АтрибутыШаблона["name"], 2));
	РеквизитыШаблона.Вставить("КодПериодичности", Число("0" + АтрибутыШаблона["idp"]));
	РеквизитыШаблона.Вставить("КодФормы",         Число("0" + АтрибутыШаблона["idf"]));
	РеквизитыШаблона.Вставить("Шифр",             АтрибутыШаблона["shifr"]);
	РеквизитыШаблона.Вставить("Версия",           АтрибутыШаблона["version"]);
	РеквизитыШаблона.Вставить("ВерсияФормата",    АтрибутыШаблона["format_version"]);
	
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Функция ДатаВерсии(СтрДата)
	
	Разделители = "-.,/";
	
	ДлинаСтроки = СтрДлина(СтрДата);
	
	МассивПолей = Новый Массив;
	МассивПолей.Добавить("");
	
	Для НС = 1 По ДлинаСтроки Цикл
		Сим = Сред(СтрДата, НС, 1);
		Если СтрНайти(Разделители, Сим) > 0 Тогда
			МассивПолей.Добавить("");
		ИначеЕсли СтрНайти("0123456789", Сим) > 0 Тогда
			МассивПолей[МассивПолей.ВГраница()] = МассивПолей[МассивПолей.ВГраница()] + Сим;
		КонецЕсли;
	КонецЦикла;
	
	День  = Макс(1, Число("0" + СокрЛП(МассивПолей[0])));
	Месяц = Макс(1, Число("0" + ?(МассивПолей.ВГраница() < 1, "1", СокрЛП(МассивПолей[1]))));
	Год   = Макс(1, Число("0" + ?(МассивПолей.ВГраница() < 2, "1", СокрЛП(МассивПолей[2]))));
	
	Возврат Дата(Год, Месяц, День);
	
КонецФункции

&НаКлиенте
Процедура Выгрузить(Команда)
	
	ТекСтроки = Элементы.Список.ВыделенныеСтроки;
		
	Если ТекСтроки.Количество() <> 0 Тогда
		
		КоличествоОшибок = 0;
		
		#Если НЕ ВебКлиент Тогда
			
			Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
			Диалог.Заголовок = "Выберите каталог для сохранения";
			
			Если Диалог.Выбрать() Тогда
				
				КаталогСохранения = ?(Прав(Диалог.Каталог, 1) = "\", Диалог.Каталог, Диалог.Каталог + "\");
				
				ШаблоныЭВФ = ПолучитьИзВременногоХранилища(ПолучитьШаблоны(ТекСтроки, КоличествоОшибок));
				
				СписокСуществующихОбъектов = Новый СписокЗначений;
		
				Для Каждого ШаблонЭВФ Из ШаблоныЭВФ Цикл
					
					КороткоеИмяФайла = ШаблонЭВФ.ИмяФайлаШаблона;
					ПолноеИмяСохраняемогоФайла = КаталогСохранения + КороткоеИмяФайла;
					ОбъектСохраняемыйФайл = Новый Файл(ПолноеИмяСохраняемогоФайла);
					
					Если ОбъектСохраняемыйФайл.Существует() Тогда
						СписокСуществующихОбъектов.Добавить(ШаблонЭВФ, КороткоеИмяФайла);
					Иначе
						Попытка
							ШаблонЭВФ.Шаблон.Записать(ПолноеИмяСохраняемогоФайла);
						Исключение
							Сообщение = Новый СообщениеПользователю;
							Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Во время сохранения файла %1 возникла ошибка:%2'"), КороткоеИмяФайла, Символы.ПС + ОписаниеОшибки());
							Сообщение.Сообщить();
							КоличествоОшибок = КоличествоОшибок + 1;
						КонецПопытки;
					КонецЕсли;
				КонецЦикла;
				
				Если СписокСуществующихОбъектов.Количество() = 1 Тогда
					ШаблонЭВФ = СписокСуществующихОбъектов[0].Значение;
					КороткоеИмяФайла = ШаблонЭВФ.ИмяФайлаШаблона;
					ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='В выбранном каталоге уже существует файл %1.%2Заменить указанный файл?'"),
						КороткоеИмяФайла, Символы.ПС);
					ДополнительныеПараметры = Новый Структура("КаталогСохранения, КороткоеИмяФайла, Сообщение, ТекСтроки, ШаблонЭВФ, КоличествоОшибок", КаталогСохранения, КороткоеИмяФайла, Сообщение, ТекСтроки, ШаблонЭВФ, КоличествоОшибок);
					ОписаниеОповещения = Новый ОписаниеОповещения("ВопросЗаменитьСуществующийФайлЗавершение", ЭтотОбъект, ДополнительныеПараметры);
					ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
				ИначеЕсли СписокСуществующихОбъектов.Количество() > 1 Тогда
					ДополнительныеПараметры = Новый Структура("КаталогСохранения, Сообщение, ТекСтроки, СписокСуществующихОбъектов, КоличествоОшибок", КаталогСохранения, Сообщение, ТекСтроки, СписокСуществующихОбъектов, КоличествоОшибок);
					ОписаниеОповещения = Новый ОписаниеОповещения("ОтметитьЭлементыДляЗаменыЗавершение", ЭтотОбъект, ДополнительныеПараметры);
					СписокСуществующихОбъектов.ПоказатьОтметкуЭлементов(ОписаниеОповещения, НСтр("ru='Файлы существуют. Отметьте файлы для замены.'"));
				Иначе
					ПоказатьПредупреждениПослеВыгрузкиШаблонов(КоличествоОшибок, ТекСтроки);
				КонецЕсли;
			КонецЕсли;
			
		#Иначе
			
			ШаблоныЭВФ = ПолучитьИзВременногоХранилища(ПолучитьШаблоны(ТекСтроки, КоличествоОшибок, Истина));
			
			Для Каждого ШаблонЭВФ Из ШаблоныЭВФ Цикл
				
				КороткоеИмяФайла = ШаблонЭВФ.ИмяФайлаШаблона;
				
				ПолучитьФайл(ШаблонЭВФ.Шаблон, ШаблонЭВФ.ИмяФайлаШаблона);
				
			КонецЦикла;
			
			
		#КонецЕсли
		
	Иначе
		
		ПоказатьПредупреждение(,СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Выберите XML-шаблоны, которые следует сохранить на диск, и повторите попытку.%1Для множественного выбора используйте клавишу Ctrl.'"), Символы.ПС));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьЭлементыДляЗаменыЗавершение(Список, ДополнительныеПараметры) Экспорт
	
	КаталогСохранения = ДополнительныеПараметры.КаталогСохранения;
	Сообщение = ДополнительныеПараметры.Сообщение;
	ТекСтроки = ДополнительныеПараметры.ТекСтроки;
	СписокСуществующихОбъектов = ДополнительныеПараметры.СписокСуществующихОбъектов;
	КоличествоОшибок = ДополнительныеПараметры.КоличествоОшибок;
	
	Для Каждого ЭлементСписка ИЗ СписокСуществующихОбъектов Цикл
		Если НЕ ЭлементСписка.Пометка Тогда
			Продолжить;
		КонецЕсли;
		ШаблонМашиночитаемойФормы = ЭлементСписка.Значение;
		КороткоеИмяФайла = ШаблонМашиночитаемойФормы.ИмяФайлаШаблона;
		ПолноеИмяСохраняемогоФайла = КаталогСохранения + КороткоеИмяФайла;
		Попытка
			ШаблонМашиночитаемойФормы.Шаблон.Записать(ПолноеИмяСохраняемогоФайла);
		Исключение
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Во время сохранения файла %1 возникла ошибка:%2'"), КороткоеИмяФайла, Символы.ПС + ОписаниеОшибки());
			Сообщение.Сообщить();
			КоличествоОшибок = КоличествоОшибок + 1;
		КонецПопытки;
	КонецЦикла;
	
	ПоказатьПредупреждениПослеВыгрузкиШаблонов(КоличествоОшибок, ТекСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗаменитьСуществующийФайлЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	КаталогСохранения = ДополнительныеПараметры.КаталогСохранения;
	КороткоеИмяФайла = ДополнительныеПараметры.КороткоеИмяФайла;
	Сообщение = ДополнительныеПараметры.Сообщение;
	ТекСтроки = ДополнительныеПараметры.ТекСтроки;
	ШаблонЭВФ = ДополнительныеПараметры.ШаблонЭВФ;
	КоличествоОшибок = ДополнительныеПараметры.КоличествоОшибок;
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Попытка
			ПолноеИмяСохраняемогоФайла = КаталогСохранения + КороткоеИмяФайла;
			ШаблонЭВФ.Шаблон.Записать(ПолноеИмяСохраняемогоФайла);
		Исключение
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Во время сохранения файла %1 возникла ошибка:%2'"), КороткоеИмяФайла, Символы.ПС + ОписаниеОшибки());
			Сообщение.Сообщить();
			КоличествоОшибок = КоличествоОшибок + 1;
		КонецПопытки;
	КонецЕсли;
	
	ПоказатьПредупреждениПослеВыгрузкиШаблонов(КоличествоОшибок, ТекСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПредупреждениПослеВыгрузкиШаблонов(Знач КоличествоОшибок, Знач ТекСтроки)
	
	Если ТекСтроки.Количество() = 1 Тогда
		Если КоличествоОшибок = 0 Тогда
			ПоказатьПредупреждение(,НСтр("ru='XML-шаблон успешно выгружен.'"));
		КонецЕсли;
	Иначе
		Если КоличествоОшибок = 0 Тогда
			ПоказатьПредупреждение(,НСтр("ru='XML-шаблоны успешно выгружены.'"));
		Иначе
			ПоказатьПредупреждение(,СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Во время сохранения произошли ошибки. Не удалось сохранить XML-шаблонов: %1.'"), КоличествоОшибок));
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПолучитьШаблоны(ТекСтроки, КоличествоОшибок, ВозвращатьВСтруктуреСсылкуНаШаблонВоВременномХранилище = Ложь)
	
	ИменаФайловШаблонов = Новый Массив;
	
	Для Каждого ТекСтрока Из ТекСтроки Цикл
		ИменаФайловШаблонов.Добавить(ТекСтрока.ИмяФайлаШаблона);
	КонецЦикла;
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ШаблоныЭВФОтчетовСтатистики.ИмяФайлаШаблона КАК ИмяФайлаШаблона,
	|	ШаблоныЭВФОтчетовСтатистики.Шаблон
	|ИЗ
	|	РегистрСведений.ШаблоныЭВФОтчетовСтатистики КАК ШаблоныЭВФОтчетовСтатистики
	|ГДЕ
	|	ШаблоныЭВФОтчетовСтатистики.ИмяФайлаШаблона В(&ИменаФайловШаблона)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ИмяФайлаШаблона");
	
	Запрос.УстановитьПараметр("ИменаФайловШаблона", ИменаФайловШаблонов);
	Выборка = Запрос.Выполнить().Выбрать();
	
	ШаблоныЭВФ = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		
		ШаблонЭВФ = Новый Структура;
		ШаблонЭВФ.Вставить("ИмяФайлаШаблона", Выборка.ИмяФайлаШаблона);
			
		Попытка
			
			Если ВозвращатьВСтруктуреСсылкуНаШаблонВоВременномХранилище Тогда
				
				ШаблонЭВФ.Вставить("Шаблон", ПоместитьВоВременноеХранилище(Выборка.Шаблон.Получить(), УникальныйИдентификатор));
				
			Иначе
				
				ШаблонЭВФ.Вставить("Шаблон", Выборка.Шаблон.Получить());
				
			КонецЕсли;	
			
			ШаблоныЭВФ.Добавить(ШаблонЭВФ);
			
		Исключение
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Во время получения XML-шаблона %1 возникла ошибка:%2'"), Выборка.ИмяФайлаШаблона, Символы.ПС + ОписаниеОшибки());
			Сообщение.Сообщить();
			
			КоличествоОшибок = КоличествоОшибок + 1;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Возврат ПоместитьВоВременноеХранилище(ШаблоныЭВФ, Новый УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура Удалить(Команда)
	
	УдалитьШаблоныНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьШаблоныНаКлиенте()
	
	ТекСтроки = Элементы.Список.ВыделенныеСтроки;
	
	КоличествоСтрок = ТекСтроки.Количество();
	
	Если КоличествоСтрок <> 0 Тогда
		
		ТекстВопроса = ?(КоличествоСтрок = 1, "Удалить XML-шаблон?", "Удалить выбранные XML-шаблоны?");
		ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьШаблоныНаКлиентеЗавершение", ЭтотОбъект, Новый Структура("ТекСтроки", ТекСтроки));
		ПоказатьВопрос(ОписаниеОповещения, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1'"), ТекстВопроса), РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ПоказатьПредупреждение(,СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Выберите XML-шаблоны, которые следует удалить, и повторите попытку.%1Для множественного выбора используйте клавишу Ctrl.'"), Символы.ПС));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьШаблоныНаКлиентеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ТекСтроки = ДополнительныеПараметры.ТекСтроки;

	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьШаблоныНаСервере(ТекСтроки);
	
	Оповестить("ИзменениеДанныхРегистраШаблоныЭВФОтчетовСтатистики");
	
КонецПроцедуры

&НаСервере
Процедура УдалитьШаблоныНаСервере(ТекСтроки)
	
	ИменаФайловШаблонов = Новый Массив;
	Для Каждого ТекСтрока Из ТекСтроки Цикл
		ИменаФайловШаблонов.Добавить(ТекСтрока.ИмяФайлаШаблона);
	КонецЦикла;
	
	МенеджерЗаписи = РегистрыСведений.ШаблоныЭВФОтчетовСтатистики.СоздатьМенеджерЗаписи();
	Для Каждого ИмяФайлаШаблона Из ИменаФайловШаблонов Цикл
		МенеджерЗаписи.ИмяФайлаШаблона = ИмяФайлаШаблона;
		МенеджерЗаписи.Удалить();
	КонецЦикла;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправлениеДоступностьюЭУ();
	ЗагрузитьНастройкиОтображенияШаблоновВДереве();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеДоступностьюЭУ()
	
	ЕстьДоступНаЗапись = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ШаблоныЭВФОтчетовСтатистики);
	
	Если НЕ ЕстьДоступНаЗапись Тогда
		Элементы.Список.ТолькоПросмотр = Истина;
		Элементы.ФормаЗагрузить.Доступность = Ложь;
		Элементы.ФормаУдалить.Доступность = Ложь;
		Элементы.ОтображатьВДеревеРеализованные.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиОтображенияШаблоновВДереве()
	Попытка
		ТекущиеНастройки = ХранилищеСистемныхНастроек.Загрузить("СтатистическаяОтчетность.ОтображатьВДеревеРеализованные", "ОтображатьВДеревеРеализованные");
		ОтображатьВДеревеРеализованные = Ложь;
		
		Если ТипЗнч(ТекущиеНастройки) = Тип("Булево") Тогда 
			ОтображатьВДеревеРеализованные = ТекущиеНастройки;
		КонецЕсли;
	Исключение
		ОтображатьВДеревеРеализованные = Ложь;
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ПриЗакрытииНаСервере(ОтображатьВДеревеРеализованные);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриЗакрытииНаСервере(ОтображатьВДеревеРеализованные)
	ХранилищеСистемныхНастроек.Сохранить("СтатистическаяОтчетность.ОтображатьВДеревеРеализованные", "ОтображатьВДеревеРеализованные", ОтображатьВДеревеРеализованные);
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ДобавитьШаблоны();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	УдалитьШаблоныНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	#Если НЕ ВебКлиент Тогда
		
		ДополнительныеПараметры = Новый Структура("ВыбраннаяСтрока", ВыбраннаяСтрока);
		ОписаниеОповещения = Новый ОписаниеОповещения("СписокВыборЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ТекстВопроса = НСтр("ru='XML-шаблон будет выгружен на диск и открыт. Продолжить?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	#КонецЕсли
		
КонецПроцедуры

&НаКлиенте
Процедура СписокВыборЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	#Если НЕ ВебКлиент Тогда
		
		ВыбраннаяСтрока = ДополнительныеПараметры.ВыбраннаяСтрока;
		
		Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;
		
		АдресВременногоХранилища = ПолучитьШаблонНаСервере(ВыбраннаяСтрока);
		
		Если НЕ АдресВременногоХранилища = Неопределено Тогда
			
			ШаблонЭВФ = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
			
			ВремФайл = ПолучитьИмяВременногоФайла("." + ШаблонЭВФ.ИмяФайлаШаблона);
			
			Попытка
				
				ШаблонЭВФ.Шаблон.Записать(ВремФайл);
				
			Исключение
				
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не удалось выгрузить XML-шаблон во временный файл на диске:%1'"), Символы.ПС + ОписаниеОшибки());
				Сообщение.Сообщить();
				
				Возврат;
				
			КонецПопытки;
			
			ЗапуститьПриложение(ВремФайл);
			
		КонецЕсли;
		
	#КонецЕсли

КонецПроцедуры

&НаСервере
Функция ПолучитьШаблонНаСервере(ВыбраннаяСтрока)
		
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                      |	ШаблоныЭВФОтчетовСтатистики.Шаблон,
	                      |	ШаблоныЭВФОтчетовСтатистики.ИмяФайлаШаблона
	                      |ИЗ
	                      |	РегистрСведений.ШаблоныЭВФОтчетовСтатистики КАК ШаблоныЭВФОтчетовСтатистики
	                      |ГДЕ
	                      |	ШаблоныЭВФОтчетовСтатистики.ИмяФайлаШаблона = &ИмяФайлаШаблона");
	Запрос.УстановитьПараметр("ИмяФайлаШаблона", ВыбраннаяСтрока.ИмяФайлаШаблона);
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ШаблонЭВФ = Новый Структура("ИмяФайлаШаблона, Шаблон");
	
	Выборка = РезультатЗапроса.Выбрать();
		
	Если Выборка.Следующий() Тогда

		ШаблонЭВФ.Вставить("ИмяФайлаШаблона", Выборка.ИмяФайлаШаблона);
			
		Попытка
			
			ШаблонЭВФ.Вставить("Шаблон", Выборка.Шаблон.Получить());
			
		Исключение
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не удалось получить XML-шаблон из хранилища:%1'"), Символы.ПС + ОписаниеОшибки());
			Сообщение.Сообщить();
			
			Возврат Неопределено;
			
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат ПоместитьВоВременноеХранилище(ШаблонЭВФ, Новый УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти