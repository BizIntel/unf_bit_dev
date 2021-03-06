﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Заявление = Параметры.Заявление;
	
	// 1. Если в мастере произойдет ошибка, мы не должны опять показывать это заявление.
	// 2. Если в мастере нажали на крестик закрытия, вместо кнопки, мы не должны опять показывать это заявление -
	//	 отказ от серверных вызовов при закрытии формы.
	// Для этого откладываем его показ на некоторое время.
	НапоминитьПозжеПроЗаявление(Заявление);
	
	Одобрено 				= Заявление.Статус = Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Одобрено;
	ЭтоВторичноеЗаявление	= Заявление.ТипЗаявления = Перечисления.ТипыЗаявленияАбонентаСпецоператораСвязи.Изменение;
	Организация 			= Заявление.Организация;
	
	УправлениеЭУ();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаНачатьИспользование(Команда)

	ОписаниеОповещения = Новый ОписаниеОповещения("КомандаНачатьИспользованиеЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНачатьИспользованиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
	Если Одобрено Тогда
		
		РеквизитыДокумента 		= ОбработкаЗаявленийАбонентаВызовСервера.ПолучитьСтруктуруРеквизитовЗаявления(Заявление);
		РезультатОтветаСервера 	= ОбработкаЗаявленийАбонентаВызовСервера.ПолучитьИРазобратьОтветНаЗаявление(Заявление, Истина);
		
		Если РезультатОтветаСервера.Выполнено Тогда
			
			ИдентификаторАбонента 	= ВРег(РезультатОтветаСервера.ИдентификаторАбонента);
			
			// Идентификатора для ЭЦП в облаке может и не быть.
			Если ЗначениеЗаполнено(ИдентификаторАбонента) Тогда
				
				СтруктураПараметров = Новый Структура();
				СтруктураПараметров.Вставить("Ключ", 								Заявление);
				СтруктураПараметров.Вставить("ЭтоЭлектроннаяПодписьВМоделиСервиса", Истина);
				СтруктураПараметров.Вставить("ИдентификаторАбонента", 				ИдентификаторАбонента);
				СтруктураПараметров.Вставить("ОтпечатокСертификатаИзОтвета", 		РезультатОтветаСервера.ОтпечатокСертификатаИзОтвета);
				
				Если Одобрено Тогда
					СтруктураПараметров.Вставить(
						"НовыйСтатусДокумента", 
						ПредопределенноеЗначение("Перечисление.СтатусыЗаявленияАбонентаСпецоператораСвязи.Одобрено"));
				Иначе
					СтруктураПараметров.Вставить(
						"НовыйСтатусДокумента", 
						ПредопределенноеЗначение("Перечисление.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отклонено"));
				КонецЕсли;
					
				СтруктураПараметров.Вставить("КонтекстЭДОКлиент", КонтекстЭДОКлиент);
					
				Закрыть(СтруктураПараметров);

			КонецЕсли;
			
		Иначе
			
			Если НЕ РезультатОтветаСервера.УдалосьСоединиться Тогда
				
				ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ПоказатьДиалогОшибкиДоступаВИнтернет(
					НСтр("ru = 'Не удалось обратиться к серверу регистрации'"));
				
			КонецЕсли;
			
		КонецЕсли;
	
	Иначе
		
		// Если статус заявления - "Отклонено", тогда создаем новое заявление
		ПараметрыФормы = Новый Структура("ЗначениеКопирования", Заявление);
		ОткрытьФорму("Документ.ЗаявлениеАбонентаСпецоператораСвязи.ФормаОбъекта", ПараметрыФормы,, Истина);

		// Проставляем флаг, что заявление обработано и больше о нем напоминать не нужно.
		ОбработкаЗаявленийАбонентаВызовСервера.ОбновитьРеквизитыЗаявления(
			Заявление, Новый Структура("НастройкаЗавершена", Истина));
						
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НапомнитьПозже(Команда = Неопределено)
	
	НапоминитьПозжеПроЗаявление(Заявление);
	// Ищем следующее заявления уже после добавления текущего в список на "Напомнить позже",
	// иначе при поиске следующего заявления мы опять на него натолкнемся.
	ОбработкаЗаявленийАбонентаКлиент.ПодключитьОбработчикПроверкиЗаявлений(2);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаБольшеНеНапоминать(Команда)
	
	НапоминитьПозжеПроЗаявление(Заявление, Истина);
	// Ищем следующее заявления уже после добавления текущего в список на "Напомнить позже",
	// иначе при поиске следующего заявления мы опять на него натолкнемся.
	ОбработкаЗаявленийАбонентаКлиент.ПодключитьОбработчикПроверкиЗаявлений(2);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура НапоминитьПозжеПроЗаявление(ЗаявлениеАбонента, БольшеНеНапоминать = Ложь) Экспорт
	
	Если БольшеНеНапоминать
		И ЗаявлениеАбонента.Статус = Перечисления.СтатусыЗаявленияАбонентаСпецоператораСвязи.Отклонено Тогда
		
		// Для отклоненных заявлений не запоминаем признак "Больше не показывать".
		// Проставляем флаг, что заявление обработано и больше о нем напоминать не нужно.
		ОбработкаЗаявленийАбонентаВызовСервера.ОбновитьРеквизитыЗаявления(
			ЗаявлениеАбонента.Ссылка, 
			Новый Структура("НастройкаЗавершена", Истина));
			
	Иначе
		
		Заявления = ХранилищеОбщихНастроек.Загрузить(ОбработкаЗаявленийАбонента.КлючЗаявленийТребующихНапоминанияПозже());
		
		Если Заявления = Неопределено Тогда
			Заявления = ТаблицаЗаявленийТребующихНапоминанияПозже();
		КонецЕсли;
		
		ЗаявлениеВТаблице = Заявления.Найти(ЗаявлениеАбонента, "Заявление");
		Если ЗаявлениеВТаблице = Неопределено Тогда
			ЗаявлениеВТаблице = Заявления.Добавить();
			ЗаявлениеВТаблице.Заявление = ЗаявлениеАбонента;
		Конецесли;
		
		Если БольшеНеНапоминать Тогда
			// Откладываем на "конец времен".
			ЗаявлениеВТаблице.Дата = Дата(3999, 12, 31, 23, 59, 59);
		Иначе
			// Откладываем показ на 4 часа.
			ЗаявлениеВТаблице.Дата = ТекущаяДатаСеанса() + 4 * 60 * 60;
		КонецЕсли;

		ХранилищеОбщихНастроек.Сохранить(ОбработкаЗаявленийАбонента.КлючЗаявленийТребующихНапоминанияПозже(), , Заявления);
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УправлениеЭУ()
	
	СформироватьНадпись();
	СформироватьЗаголовок();
	СформироватьЗаголовокКнопок();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьНадпись()
	
	Если ЭтоВторичноеЗаявление Тогда
		ВидЗаявления = НСтр("ru = 'Заявление №%1 на изменение подключения'");
	Иначе
		ВидЗаявления = НСтр("ru = 'Заявление №%1 на подключение'");
	КонецЕсли;
	
	НомерЗаявления = СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Заявление.Номер, "0");
	
	ВидЗаявления = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ВидЗаявления,
		НомерЗаявления);
	
	СсылкаНаЗаявление = Новый ФорматированнаяСтрока(ВидЗаявления,,,,ПолучитьНавигационнуюСсылку(Заявление));
	
	Если Одобрено Тогда
		Результат = НСтр("ru = 'одобрено'");
	Иначе
		Результат = НСтр("ru = 'отклонено'");
	КонецЕсли;
	
	ТекстОповещения = Новый ФорматированнаяСтрока(НСтр("ru = ' организации ""%1"" к 1С-Отчетности %2.'"));

	Если НЕ Одобрено Тогда
		// Указываем причину, по которой заявление отклонено.
		ТекстОповещения = Новый ФорматированнаяСтрока(
			ТекстОповещения,
			Символы.ПС,
			Заявление.СтатусКомментарий);
	КонецЕсли;
		
	Если Одобрено Тогда
		ЧтоНужноСделать = НСтр("ru = 'Для завершения нужно выполнить несколько простых шагов.'");
	Иначе
		ЧтоНужноСделать = НСтр("ru = 'Устраните проблему и отправьте новое заявление.'");
	КонецЕсли;
	
	// Добавляем совет (что нужно делать)
	ТекстОповещения = Новый ФорматированнаяСтрока(
			ТекстОповещения,
			Символы.ПС,
			ЧтоНужноСделать);
			
	// Подставляем организацию и итог одобрения заявления.
	ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстОповещения,
			Организация,
			Результат);
			
	// Склеиваем ссылку на заявление с остальной получившейся строкой.
	ТекстОповещения = Новый ФорматированнаяСтрока(
		СсылкаНаЗаявление,
		ТекстОповещения);
			
	Элементы.ТекстОповещения.Заголовок 	= ТекстОповещения;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьЗаголовок()
	
	Если ЭтоВторичноеЗаявление Тогда
		ВидЗаявления = НСтр("ru = 'Заявление на изменение подключения к 1С-Отчетности '");
	Иначе
		ВидЗаявления = НСтр("ru = 'Заявление на подключение к 1С-Отчетности '");
	КонецЕсли;
	
	Если Одобрено Тогда
		Результат = НСтр("ru = 'одобрено'");
	Иначе
		Результат = НСтр("ru = 'отклонено'");
	КонецЕсли;
	
	Заголовок = Новый ФорматированнаяСтрока(
		ВидЗаявления,
		Результат);
	
КонецПроцедуры
	
&НаСервере
Процедура СформироватьЗаголовокКнопок()
	
	Если Одобрено Тогда
		Элементы.КнопкаНачатьИспользование.Заголовок = НСтр("ru = 'Продолжить сейчас'");
	Иначе
		Элементы.КнопкаНачатьИспользование.Заголовок = НСтр("ru = 'Подготовить новое заявление'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТаблицаЗаявленийТребующихНапоминанияПозже()

	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Заявление", 	Новый ОписаниеТипов("ДокументСсылка.ЗаявлениеАбонентаСпецоператораСвязи"));
	Таблица.Колонки.Добавить("Дата", 		Новый ОписаниеТипов("Дата")); // Когда следует начинать напоминать.
	
	Возврат Таблица;

КонецФункции

#КонецОбласти

