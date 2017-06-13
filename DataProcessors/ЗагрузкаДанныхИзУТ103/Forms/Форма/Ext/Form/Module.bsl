﻿
&НаСервере
Процедура ЗагрузитьНаСервере(АдресВременногоХранилища)
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	// получаем имя временного файла в локальной ФС на сервере
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	// получаем файл правил для зачитки
	ДвоичныеДанные.Записать(ИмяВременногоФайла);
	ДвоичныеДанные = Неопределено;
	
	УникальныйИдентификатор_        = Новый УникальныйИдентификатор();
	ИмяВременногоФайлаПротоколаОбмена = КаталогВременныхФайлов() + УникальныйИдентификатор_ + ".txt";
	
	УОД = Обработки.УниверсальныйОбменДаннымиXML.Создать();
	УОД.ИмяФайлаОбмена                        = ИмяВременногоФайла;
	УОД.РежимОбмена                           = "Загрузка";
	УОД.ЗапоминатьЗагруженныеОбъекты          = Ложь;
	УОД.ВыводВПротоколСообщенийОбОшибках      = Истина;
	УОД.ВыводВПротоколИнформационныхСообщений = Ложь;
	УОД.ИмяФайлаПротоколаОбмена               = ИмяВременногоФайлаПротоколаОбмена;
	
	УОД.ЗагружатьДанныеВРежимеОбмена               = Истина;
	УОД.ОбъектыПоСсылкеЗагружатьБезПометкиУдаления = Истина;
	УОД.ОптимизированнаяЗаписьОбъектов             = Истина;
	УОД.ЗапоминатьЗагруженныеОбъекты               = Истина;
	УОД.ЭтоИнтерактивныйРежим                      = Истина;
	
	УОД.ФлагРежимОтладкиОбработчиков = Истина;
	УОД.ИмяФайлаВнешнейОбработкиОбработчиковСобытий = "ОбработчикиЗагрузкиИзУправлениеТорговлей103";
	
	УстановитьПривилегированныйРежим(Истина);
	УОД.ВыполнитьЗагрузку();
	УстановитьПривилегированныйРежим(Ложь);
	
	ПротоколОбмена = Новый ТекстовыйДокумент;
	ПротоколОбмена.Прочитать(ИмяВременногоФайлаПротоколаОбмена);
	
	Попытка
		УдалитьФайлы(ИмяВременногоФайлаПротоколаОбмена);  // Удаляем временный файл правил
	Исключение
	КонецПопытки;
	
	Элементы.ПротоколОбмена.Видимость = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	
	Попытка
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьЗавершение", ЭтотОбъект);
		
		Если НЕ РасширениеРаботыСФайламиПодключено Тогда
			НачатьПомещениеФайла(ОписаниеОповещения, АдресВременногоХранилища, "*.xml",, УникальныйИдентификатор); 
		Иначе
			НачатьПомещениеФайла(ОписаниеОповещения, АдресВременногоХранилища, ИмяФайлаОбмена, Ложь, УникальныйИдентификатор) 
		КонецЕсли;
	Исключение
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Ошибка при загрузке данных.'");
		Сообщение.Сообщить();
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьЗавершение(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт

	Если Результат Тогда
		
		АдресВременногоХранилища = Адрес;
		
		ОчиститьСообщения();
		ПротоколОбмена.Очистить();
		
		Состояние(НСтр("ru = 'Загрузка данных...'"),, НСтр("ru = 'Выполняется загрузка данных из УТ 10.3'"));
		ЗагрузитьНаСервере(АдресВременногоХранилища);
		
		ОбновитьИнтерфейс();
		СтандартныеПодсистемыКлиент.УстановитьРасширенныйЗаголовокПриложения();
		
		ПоказатьОповещениеПользователя(НСтр("ru = 'Загрузка завершена'"),,, БиблиотекаКартинок.Информация32);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаОбменаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИмяФайлаОбмена = Элемент.ТекстРедактирования;
	
	Если РасширениеРаботыСФайламиПодключено Тогда
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ДиалогОткрытияФайла.Фильтр             = "Файл выгрузки (*.xml)|*.xml";
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите путь к файлу выгрузки данных из УТ 10.3'");
		ДиалогОткрытияФайла.Каталог = ИмяФайлаОбмена;
		ДиалогОткрытияФайла.Показать(Новый ОписаниеОповещения("ИмяФайлаОбменаНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("ДиалогОткрытияФайла", ДиалогОткрытияФайла)));
	Иначе
		ПоказатьПредупреждение(Неопределено,НСтр("ru = 'Для выбора каталога необходимо установить расширение для работы с файлами в Веб-клиенте.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаОбменаНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
    
    ДиалогОткрытияФайла = ДополнительныеПараметры.ДиалогОткрытияФайла;
    
    Если (ВыбранныеФайлы <> Неопределено) Тогда
        ИмяФайлаОбмена = ДиалогОткрытияФайла.ПолноеИмяФайла;
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	НачатьПодключениеРасширенияРаботыСФайлами(Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Подключено, ДополнительныеПараметры) Экспорт
	
	РасширениеРаботыСФайламиПодключено = Подключено;
	Если НЕ РасширениеРаботыСФайламиПодключено Тогда
		Элементы.ИмяФайлаОбмена.Видимость = Ложь;
		Элементы.ПредупреждениеЗагрузка.Видимость = Истина;
	Иначе
		Элементы.ИмяФайлаОбмена.Видимость = Истина;
		Элементы.ПредупреждениеЗагрузка.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры


