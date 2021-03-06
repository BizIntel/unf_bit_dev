﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		
		Если ЗначениеЗаполнено(Параметры.Организация) Тогда
			Объект.Организация = Параметры.Организация;
		Иначе
			Организация = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.ТекущийПользователь(), "ОсновнаяОрганизация");
			Если Не ЗначениеЗаполнено(Организация) Тогда
				Организация =УправлениеНебольшойФирмойСервер.ПолучитьПредопределеннуюОрганизацию();
			КонецЕсли;
		КонецЕсли;
	
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.СобытиеКалендаря) Тогда
		Объект.СобытиеКалендаря = Параметры.СобытиеКалендаря;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.СостояниеСобытия) Тогда
		
		Если ЗначениеЗаполнено(Параметры.СостояниеСобытия) Тогда
			
			Объект.СостояниеСобытия = Параметры.СостояниеСобытия;
			
		Иначе
			
			Объект.СостояниеСобытия = КалендарьОтчетности.ПолучитьСостояниеСобытияКалендаря(
				Объект.Организация,
				Объект.СобытиеКалендаря);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДатыСобытия = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.СобытиеКалендаря, "ДатаДокументаОбработкиСобытия,ДатаНачалаДокументов,ДатаОкончанияДокументов");
	ДатаДокументаОбработкиСобытия = ДатыСобытия.ДатаДокументаОбработкиСобытия;
	
	ПолучитьДанныеОтчетности();
	
	ПериодЗадачиПредставление = ПредставлениеПериода(
		ДатыСобытия.ДатаНачалаДокументов,
		КонецДня(ДатыСобытия.ДатаОкончанияДокументов),
		"ФП=Истина");
	
	Если Год(ДатаДокументаОбработкиСобытия) > 2013 Тогда
		Элементы.ДекорацияПФРСтраховая.Заголовок = НСтр("ru = 'ПФР'");
		Элементы.ДекорацияИтого.Заголовок = НСтр("ru = 'Итого (2-в-1):'");
		Элементы.ГруппаСтрока6.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.Ознакомиться") Тогда
		
		Элементы.СтраницаВзносыВПФР.ТекущаяСтраница = Элементы.РезультатРасчета;
		
	ИначеЕсли Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.Уплатить") Тогда
		
		Элементы.СтраницаВзносыВПФР.ТекущаяСтраница = Элементы.УплатаНалога;
		
	Иначе
		
		Элементы.СтраницаВзносыВПФР.ТекущаяСтраница = Элементы.ЗадачаВыполнена;
		
	КонецЕсли;
	
	НазначитьКнопкуПоУмолчаниюИУстановитьЗаголовок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписанДокумент" Тогда
		
		Если ТипЗнч(Источник) = Тип("ДокументСсылка.РасходИзКассы") Тогда
			
			СоотвСсылок = Новый Соответствие;
			СоотвСсылок.Вставить(СсылкаДокументаНаличнойОплатыПФРНакопительная,"ДекорацияУплаченоПФРНакопительная");
			СоотвСсылок.Вставить(СсылкаДокументаНаличнойОплатыПФРСтраховая, "ДекорацияУплаченоПФРСтраховая");
			СоотвСсылок.Вставить(СсылкаДокументаНаличнойОплатыФФОМС, "ДекорацияУплаченоФФОМС");
			
			Если СоотвСсылок.Получить(Источник) = Неопределено Тогда
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ИзмененаТекущаяОрганизация" Тогда
		Если Окно.Основное Тогда
			ПерейтиПоНавигационнойСсылке("e1cib/navigationpoint/НалогиИОтчетность");
		Иначе
			Закрыть();
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ИзменениеСостоянияСобытияКалендаря" Тогда
		Если Параметр = Объект.СобытиеКалендаря
				И Источник <> ЭтаФорма
				И Окно<> Неопределено
				И Не Окно.Основное Тогда
			Попытка
				Закрыть();
			Исключение
			КонецПопытки;
		КонецЕсли;
		
	КонецЕсли;
	// Вставить содержимое обработчика.
КонецПроцедуры

//-----------------------------------------------------------------------------
// События переходов

&НаКлиенте
Процедура ПереходЗаполнение(Команда)
	
	Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.Заполнить");
	
	КалендарьОтчетности.ЗаписатьСостояниеСобытияКалендаря(
		Объект.Организация,
		Объект.СобытиеКалендаря,
		Объект.СостояниеСобытия,
		"");
	
	ПараметрыФормы = Новый Структура("Организация,СобытиеКалендаря", Объект.Организация,Объект.СобытиеКалендаря);
	
	КалендарьОтчетностиКлиент.ОткрытьФормуНачалаЗаполнения(ЭтаФорма,ПараметрыФормы);
	Оповестить("ИзменениеСостоянияСобытияКалендаря", Объект.СобытиеКалендаря, ЭтаФорма);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПереходУплата(Команда)
	
	Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.Уплатить");
	
	КалендарьОтчетности.ЗаписатьСостояниеСобытияКалендаря(
		Объект.Организация,
		Объект.СобытиеКалендаря,
		Объект.СостояниеСобытия,
		ВсегоКУплатеВПФР);
	
	Элементы.СтраницаВзносыВПФР.ТекущаяСтраница = Элементы.УплатаНалога;
	НазначитьКнопкуПоУмолчаниюИУстановитьЗаголовок();
	
	Оповестить("ИзменениеСостоянияСобытияКалендаря", Объект.СобытиеКалендаря, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереходРезультатРасчета(Команда)
	
	Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.Ознакомиться");
	
	ЗафиксироватьПереходкУплате(Объект.Организация, Объект.СобытиеКалендаря, Объект.СостояниеСобытия, ВсегоКУплатеВПФР);
	
	Элементы.СтраницаВзносыВПФР.ТекущаяСтраница = Элементы.РезультатРасчета;
	НазначитьКнопкуПоУмолчаниюИУстановитьЗаголовок();
	
	Оповестить("ИзменениеСостоянияСобытияКалендаря", Объект.СобытиеКалендаря, ЭтаФорма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗафиксироватьПереходкУплате(Организация, Событие, Состояние, ВсегоКУплате)
	
	КалендарьОтчетности.ЗаписатьСостояниеСобытияКалендаря(
		Организация,
		Событие,
		Состояние,
		ВсегоКУплате);
	
	ЗаписьКалендаря = Справочники.ЗаписиКалендаряПодготовкиОтчетности.ПолучитьЗаписьКалендаря(Организация, Событие);
	Если ЗаписьКалендаря <> Неопределено Тогда
		ОбъектЗаписьКалендаря = ЗаписьКалендаря.ПолучитьОбъект();
		ОбъектЗаписьКалендаря.Завершено = Ложь;
		ОбъектЗаписьКалендаря.Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереходВыполнил(Команда)
	
	Объект.СостояниеСобытия = ПредопределенноеЗначение("Перечисление.СостоянияСобытийКалендаря.Завершено");

	КалендарьОтчетности.ЗавершитьСобытиеКалендаряОтчетности(
		Объект.Организация,
		Объект.СобытиеКалендаря,
		"");

	Элементы.СтраницаВзносыВПФР.ТекущаяСтраница = Элементы.ЗадачаВыполнена;
	НазначитьКнопкуПоУмолчаниюИУстановитьЗаголовок();
	
	ОповеститьОбИзменении(Тип("СправочникСсылка.ЗаписиКалендаряПодготовкиОтчетности"));
	Оповестить("Запись_ЗаписиКалендаряПодготовкиОтчетности");
	
	
КонецПроцедуры


&НаКлиенте
Процедура МРОТЗаСебяНажатие(Элемент, СтандартнаяОбработка)
	ОткрытьФорму("РегистрСведений.МРОТ.ФормаСписка", Новый Структура("ДействующийНаДату", НачалоГода(ДатаДокументаОбработкиСобытия)));
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

//-----------------------------------------------------------------------------
// квитанция

&НаКлиенте
Процедура ДекорацияВсеПлатежкиНажатие(Элемент)
	
	оп = Новый ОписаниеОповещения("ПолучениеДанныхПлатежек", ЭтотОбъект, Новый Структура("Файл", Ложь));
	ПолучитьСписокПлатежек(оп);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияВсеФайлыНажатие(Элемент)
	
	оп = Новый ОписаниеОповещения("ПолучениеДанныхПлатежек", ЭтотОбъект, Новый Структура("Файл", Истина));
	ПолучитьСписокПлатежек(оп);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучениеДанныхПлатежек(БанкСчетСтруктура, Параметры) Экспорт
	
	Если Параметры.Файл Тогда
		Если БанкСчетСтруктура <> Неопределено Тогда
			Если ПроверитьНаличиеГосОргана("ПолучитьФайлКлиентБанка") Тогда
				ПолучитьСписокПлатежекНаСервере();
				СписокПлатежек = Новый СписокЗначений;
				Если ПФРНакопительнаяЗаСебя <> "0,00 р." Тогда
					СписокПлатежек.Добавить(СсылкаДокументаБезналичнойОплатыПФРНакопительная);
				КонецЕсли;
				
				Если ПФРСтраховаяЗаСебя <> "0,00 р." Тогда
					СписокПлатежек.Добавить(СсылкаДокументаБезналичнойОплатыПФРСтраховая);
				КонецЕсли;
				
				Если ФФОМСЗаСебя <> "0,00 р." Тогда
					СписокПлатежек.Добавить(СсылкаДокументаБезналичнойОплатыФФОМС);
				КонецЕсли;
				
				БанкСчетСтруктура.Вставить("СписокПлатежек", СписокПлатежек);
				ОткрытьФорму(
					"Обработка.КлиентБанк.Форма.СохранениеПлатежек",
					БанкСчетСтруктура);
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если ПроверитьНаличиеГосОргана("РаспечататьПлатежноеПоручениеЗавершение") Тогда
			РаспечататьПлатежноеПоручениеЗавершение();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияВсеКвитанцииНажатие(Элемент)
	
	Если ПроверитьНаличиеГосОргана("РаспечататьКвитанциюЗавершение") Тогда
		РаспечататьКвитанциюЗавершение();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтразитьРасходыВПрограмме(Команда)
	
	Список = Новый СписокЗначений;
	Список.Добавить(ДокументВзаиморасчетовСБюджетомФФОМС,НСтр("ru='ФФОМС'"));
	
	Если Год(ДатаДокументаОбработкиСобытия) < 2014 Тогда
		Список.Добавить(ДокументВзаиморасчетовСБюджетомПФРСтраховая,НСтр("ru='ПФР страховая'"));
		Список.Добавить(ДокументВзаиморасчетовСБюджетомПФРНакопительная,НСтр("ru='ПФР накопительная'"));
	Иначе
		Список.Добавить(ДокументВзаиморасчетовСБюджетомПФРСтраховая,НСтр("ru='ПФР'"));
	КонецЕсли;
	
	ОткрытьФорму(
		"Обработка.ОбработкиНалоговИОтчетности.Форма.ГрупповаяРегистрацияРасходов",
		Новый Структура(
			"Организация,СписокКПоиску", 
			Объект.Организация,
			Список));
	
КонецПроцедуры


///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ


&НаКлиенте
Процедура НазначитьКнопкуПоУмолчаниюИУстановитьЗаголовок()
	
	ИмяКнопки = ПолучитьИмяЭлементаКнопкиПоУмолчанию(Элементы.СтраницаВзносыВПФР.ТекущаяСтраница.Имя);
	
	Если НЕ ПустаяСтрока(ИмяКнопки) Тогда
		Элементы[ИмяКнопки].КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Элементы.СтраницаВзносыВПФР.ТекущаяСтраница.Заголовок, ПериодЗадачиПредставление);
	РегламентированнаяОтчетностьУСНКлиентСервер.УстановитьЗаголовокФормыЗадачи(ЭтаФорма, Объект.Организация);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьИмяЭлементаКнопкиПоУмолчанию(ИмяСтраницы)
	
	Если ИмяСтраницы = "РезультатРасчета" Тогда
		Возврат "ПереходДалее";
	ИначеЕсли ИмяСтраницы = "УплатаНалога" Тогда
		Возврат "ПереходВыполнил";
	ИначеЕсли ИмяСтраницы = "ЗадачаВыполнена" Тогда
		Возврат "";
	Иначе
		ВызватьИсключение НСтр("ru='Неизвестное имя текущей страницы'");
	КонецЕсли;
	
КонецФункции

// Процедура заполняет данные формы по данным ранее сформированной отчетности
//
&НаСервере
Процедура ПолучитьДанныеОтчетности()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЗначенияПоказателейОтчетности.ЗначениеПоказателя КАК ЗначениеПоказателя,
	|	ЗначенияПоказателейОтчетности.ПоказательОтчетности.Код КАК КодОтчетности,
	|	ЗначенияПоказателейОтчетности.ПоказательОтчетности
	|ИЗ
	|	РегистрСведений.ЗначенияПоказателейОтчетности КАК ЗначенияПоказателейОтчетности
	|ГДЕ
	|	ЗначенияПоказателейОтчетности.Организация = &Организация
	|	И ЗначенияПоказателейОтчетности.ПериодОтчетности = &ПериодОтчетности
	|	И ЗначенияПоказателейОтчетности.ПоказательОтчетности В ИЕРАРХИИ(&ГруппаПоказателя)");
	
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("ПериодОтчетности", Объект.СобытиеКалендаря.ДатаДокументаОбработкиСобытия);
	
	Запрос.УстановитьПараметр("ГруппаПоказателя", ПланыВидовХарактеристик.ПоказателиОтчетности.ВзносыВПФРиФССЗаСебя);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	МассивСуммируемыхПоказателей = Новый Массив;
	МассивСуммируемыхПоказателей.Добавить(ПланыВидовХарактеристик.ПоказателиОтчетности.ПФРНакопительнаяЗаСебя);
	МассивСуммируемыхПоказателей.Добавить(ПланыВидовХарактеристик.ПоказателиОтчетности.ПФРСтраховаяЗаСебя);
	МассивСуммируемыхПоказателей.Добавить(ПланыВидовХарактеристик.ПоказателиОтчетности.ФФОМСЗаСебя);
	
	Итого = 0;
	
	Пока Выборка.Следующий() Цикл
		ЭтаФорма[Выборка.КодОтчетности] = Формат(Выборка.ЗначениеПоказателя, "ЧДЦ=2; ЧРГ=; ЧН=" ) + " р.";
		
		Если МассивСуммируемыхПоказателей.Найти(Выборка.ПоказательОтчетности) <> Неопределено Тогда
			Итого = Итого + Выборка.ЗначениеПоказателя;
		КонецЕсли;
	КонецЦикла;
	
	ИтогоПФР = Формат(Итого, "ЧДЦ=2; ЧРГ=; ЧН=" ) + " р.";
	
	НайтиДокументыВзаиморасчетаСбюджетом();
	НайтиДокументОплаты();
	
	Если УплаченоСНачалоГОДЗаСебя = "0,00 р." Тогда
		Элементы.ГруппаСтрока11.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НайтиДокументОплаты()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	РасходДенежныхСредствИзКассы.Ссылка
	|ИЗ
	|	Документ.РасходИзКассы КАК РасходДенежныхСредствИзКассы
	|ГДЕ
	|	РасходДенежныхСредствИзКассы.Организация = &Организация
	|	И РасходДенежныхСредствИзКассы.ДокументОснование = &ДокументОснование1
	|	И РасходДенежныхСредствИзКассы.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	РасходДенежныхСредствИзКассы.Ссылка
	|ИЗ
	|	Документ.РасходИзКассы КАК РасходДенежныхСредствИзКассы
	|ГДЕ
	|	РасходДенежныхСредствИзКассы.Организация = &Организация
	|	И РасходДенежныхСредствИзКассы.ДокументОснование = &ДокументОснование2
	|	И РасходДенежныхСредствИзКассы.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	РасходДенежныхСредствИзКассы.Ссылка
	|ИЗ
	|	Документ.РасходИзКассы КАК РасходДенежныхСредствИзКассы
	|ГДЕ
	|	РасходДенежныхСредствИзКассы.Организация = &Организация
	|	И РасходДенежныхСредствИзКассы.ДокументОснование = &ДокументОснование3
	|	И РасходДенежныхСредствИзКассы.Проведен
	|;
	|");
	
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("ДокументОснование1", ДокументВзаиморасчетовСБюджетомПФРНакопительная);
	Запрос.УстановитьПараметр("ДокументОснование2", ДокументВзаиморасчетовСБюджетомПФРСтраховая);
	Запрос.УстановитьПараметр("ДокументОснование3", ДокументВзаиморасчетовСБюджетомФФОМС);

	
	Пакет = Запрос.ВыполнитьПакет();
	
	// ПФР Накопительная
	Выборка = Пакет[0].Выбрать();
	
	Если Выборка.Следующий() Тогда
		СсылкаДокументаНаличнойОплатыПФРНакопительная = Выборка.Ссылка;
	Иначе
		СсылкаДокументаНаличнойОплатыПФРНакопительная = Документы.РасходИзКассы.ПустаяСсылка();
	КонецЕсли;
	
	// ПФР Страховая
	Выборка = Пакет[1].Выбрать();
	
	Если Выборка.Следующий() Тогда
		СсылкаДокументаНаличнойОплатыПФРСтраховая = Выборка.Ссылка;
	Иначе
		СсылкаДокументаНаличнойОплатыПФРСтраховая = Документы.РасходИзКассы.ПустаяСсылка();
	КонецЕсли;
	
	// ФФОМС
	Выборка = Пакет[2].Выбрать();
	
	Если Выборка.Следующий() Тогда
		СсылкаДокументаНаличнойОплатыФФОМС = Выборка.Ссылка;
	Иначе
		СсылкаДокументаНаличнойОплатыФФОМС = Документы.РасходИзКассы.ПустаяСсылка();
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура НайтиДокументыВзаиморасчетаСБюджетом()
	
	ДатыСобытия = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.СобытиеКалендаря, "ДатаДокументаОбработкиСобытия,ДатаОкончанияСобытия");
	
	ДокументВзаиморасчетовСБюджетомПФРСтраховая = РегламентированнаяОтчетностьУСН.ПолучитьДокументВзаиморасчетовСБюджетом(
		Объект.Организация,
		Справочники.ВидыНалогов.ПФРСтраховая,
		ДатыСобытия.ДатаДокументаОбработкиСобытия,
		ДатыСобытия.ДатаОкончанияСобытия,
		Истина);
	
	ДокументВзаиморасчетовСБюджетомПФРНакопительная = РегламентированнаяОтчетностьУСН.ПолучитьДокументВзаиморасчетовСБюджетом(
		Объект.Организация,
		Справочники.ВидыНалогов.ПФРНакопительная,
		ДатыСобытия.ДатаДокументаОбработкиСобытия,
		ДатыСобытия.ДатаОкончанияСобытия,
		Истина);
	
	ДокументВзаиморасчетовСБюджетомФФОМС = РегламентированнаяОтчетностьУСН.ПолучитьДокументВзаиморасчетовСБюджетом(
		Объект.Организация,
		Справочники.ВидыНалогов.ФФОМС,
		ДатыСобытия.ДатаДокументаОбработкиСобытия,
		ДатыСобытия.ДатаОкончанияСобытия,
		Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСписокПлатежек(ОповещениеВыборПлатежек)
	
	Если Не ЗначениеЗаполнено(БанковскийСчетПоУмолчанию) Тогда
		оп = Новый ОписаниеОповещения("ОповещениеВыбораСчета", ЭтотОбъект, Новый Структура("ОповещениеВыборПлатежек", ОповещениеВыборПлатежек));
		РегламентированнаяОтчетностьУСНКлиент.ПолучитьБанковскийСчетДляУплатыНалога(оп, Объект.Организация);
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОповещениеВыборПлатежек, Новый Структура ("БанковскийСчет",БанковскийСчетПоУмолчанию))
	
КонецПроцедуры


&НаКлиенте
Процедура ОповещениеВыбораСчета(БанковскийСчет, Параметры) Экспорт
	Если ЗначениеЗаполнено(БанковскийСчет) Тогда
		СписокПлатежек = Новый СписокЗначений;
		БанковскийСчетПоУмолчанию = БанковскийСчет;
		ВыполнитьОбработкуОповещения(Параметры.ОповещениеВыборПлатежек, Новый Структура ("СписокПлатежек, БанковскийСчет",СписокПлатежек, БанковскийСчетПоУмолчанию))
		
	КонецЕсли
КонецПроцедуры


&наСервере
Процедура ПолучитьСписокПлатежекНаСервере()
	
	// Добавляем в массив
	// ПФРНакопительная
	Если ПФРНакопительнаяЗаСебя <> "0,00 р." Тогда
		СсылкаДокументаБезналичнойОплатыПФРНакопительная = РегламентированнаяОтчетностьУСН.СоздатьБезналичноеСписаниеПоВзаиморасчетамСБюджетом(ДокументВзаиморасчетовСБюджетомПФРНакопительная, БанковскийСчетПоУмолчанию);
	КонецЕсли;
	
	// ПФРСтраховая
	Если ПФРСтраховаяЗаСебя <> "0,00 р." Тогда
		СсылкаДокументаБезналичнойОплатыПФРСтраховая = РегламентированнаяОтчетностьУСН.СоздатьБезналичноеСписаниеПоВзаиморасчетамСБюджетом(ДокументВзаиморасчетовСБюджетомПФРСтраховая, БанковскийСчетПоУмолчанию);
	КонецЕсли;
	
	// ФФОМС
	Если ФФОМСЗаСебя <> "0,00 р." Тогда
		СсылкаДокументаБезналичнойОплатыФФОМС = РегламентированнаяОтчетностьУСН.СоздатьБезналичноеСписаниеПоВзаиморасчетамСБюджетом(ДокументВзаиморасчетовСБюджетомФФОМС, БанковскийСчетПоУмолчанию);
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура РаспечататьКвитанциюЗавершение() Экспорт
	
	СписокДокументов = Новый Массив;
	
	Если Год(ДатаДокументаОбработкиСобытия) < 2014 Тогда
		СписокДокументов.Добавить(ДокументВзаиморасчетовСБюджетомПФРНакопительная);
	КонецЕсли;
	СписокДокументов.Добавить(ДокументВзаиморасчетовСБюджетомПФРСтраховая);
	СписокДокументов.Добавить(ДокументВзаиморасчетовСБюджетомФФОМС);
	
	СтруктураПечати = ВыгрузитьДокументВФайл(СписокДокументов, "Квитанция");
	Если СтруктураПечати.АдресФайла = Неопределено Тогда
		
		Сообщить(Нстр("ru='Произошла ошибка при выгрузке документа '")+Объект);
		Возврат;
		
	КонецЕсли;
	
	ПолучитьФайл(СтруктураПечати.АдресФайла, СтруктураПечати.НаименованиеФайла, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура РаспечататьПлатежноеПоручениеЗавершение() Экспорт
	
	ПолучитьСписокПлатежекНаСервере();
	
	СписокДокументов = Новый Массив;
	
	Если ПФРНакопительнаяЗаСебя <> "0,00 р." Тогда
		СписокДокументов.Добавить(СсылкаДокументаБезналичнойОплатыПФРНакопительная);
	КонецЕсли;
	
	Если ПФРСтраховаяЗаСебя <> "0,00 р." Тогда
		СписокДокументов.Добавить(СсылкаДокументаБезналичнойОплатыПФРСтраховая);
	КонецЕсли;
	
	Если ФФОМСЗаСебя <> "0,00 р." Тогда
		СписокДокументов.Добавить(СсылкаДокументаБезналичнойОплатыФФОМС);
	КонецЕсли;
	
	СтруктураПечати = ВыгрузитьДокументВФайл(СписокДокументов, "ПлатежноеПоручение");
	Если СтруктураПечати.АдресФайла = Неопределено Тогда
		
		Сообщить(Нстр("ru='Произошла ошибка при выгрузке документа '")+Объект);
		Возврат;
		
	КонецЕсли;
	
	ПолучитьФайл(СтруктураПечати.АдресФайла, СтруктураПечати.НаименованиеФайла, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьФайлКлиентБанка() Экспорт
	
	БанкСчетСтруктура = Новый Структура("БанковскийСчет", БанковскийСчетПоУмолчанию);
	
	ПолучитьСписокПлатежекНаСервере();
	СписокПлатежек = Новый СписокЗначений;
	Если ПФРНакопительнаяЗаСебя <> "0,00 р." Тогда
		СписокПлатежек.Добавить(СсылкаДокументаБезналичнойОплатыПФРНакопительная);
	КонецЕсли;
	
	Если ПФРСтраховаяЗаСебя <> "0,00 р." Тогда
		СписокПлатежек.Добавить(СсылкаДокументаБезналичнойОплатыПФРСтраховая);
	КонецЕсли;
	
	Если ФФОМСЗаСебя <> "0,00 р." Тогда
		СписокПлатежек.Добавить(СсылкаДокументаБезналичнойОплатыФФОМС);
	КонецЕсли;
	
	БанкСчетСтруктура.Вставить("СписокПлатежек", СписокПлатежек);
	
	ОткрытьФорму(
		"Обработка.КлиентБанк.Форма.СохранениеПлатежек",
		БанкСчетСтруктура);
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьНаличиеГосОргана(ИмяПроцедурыПоЗавершениюСозданияГосОргана)
	КодГосОргана = "";
	
	Если ГосОрганСуществует(Объект.Организация, КодГосОргана) Тогда
		Возврат Истина;
	Иначе
		ДопПараметры = Новый Структура("ИмяПроцедурыПоЗавершениюСозданияГосОргана, КодГосОргана", ИмяПроцедурыПоЗавершениюСозданияГосОргана, КодГосОргана);
		ТекстВопроса = НСтр("ru='В справочнике «Контрагенты» не задан налоговый орган для уплаты взноса.
			|Создать его автоматически?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриОтветеНаВопросОСозданииГосОргана",
			ЭтаФорма, ДопПараметры);
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Создать автоматически'"));
		Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Создать вручную'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru='Отмена'"));
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки,,КодВозвратаДиалога.Да, НСтр("ru='Отсутствует налоговый орган'"));
		
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПриОтветеНаВопросОСозданииГосОргана(РезультатВопроса, ДопПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ВыполнитьЗаполнениеСведенийОбОтделенииПФРПоКоду(ДопПараметры);
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ВидГосударственногоОргана", ПредопределенноеЗначение("Перечисление.ВидыГосударственныхОрганов.ОрганПФР"));
		ПараметрыФормы.Вставить("КодГосударственногоОргана", ДопПараметры.КодГосОргана);
		ПараметрыФормы.Вставить("ИмяПроцедурыПоЗавершениюСозданияГосОргана",ДопПараметры.ИмяПроцедурыПоЗавершениюСозданияГосОргана);
		ПараметрыФормы.Вставить("ЗапретРедактированияКода", Истина);
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьИзменениеПлатежныхРеквизитовФНС", ЭтотОбъект, ПараметрыФормы);
		
		ОткрытьФорму("Справочник.Контрагенты.Форма.РеквизитыГосударственныхОрганов", ПараметрыФормы, ЭтотОбъект, ЭтотОбъект, , , ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗаполнениеСведенийОбОтделенииПФРПоКоду(ДопПараметры)
	
	ОписаниеОшибки = "";
	ЗаполнитьСведенияОбОтделенииПФРПоКоду(ОписаниеОшибки, ДопПараметры.КодГосОргана);
	
	// Обработка ошибок
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		Если ОписаниеОшибки = "НеУказаныПараметрыАутентификации" Тогда
			
			ТекстВопроса = НСтр("ru='Для автоматического создания налогового органа
				|в справочнике «Контрагенты» необходимо подключиться к Интернет-поддержке
				|пользователей. Подключиться сейчас?'");
				
			ПараметрыВопроса = Новый Структура("ВызовПослеПодключения,ИмяПроцедурыПоЗавершениюСозданияГосОргана", "ЗаполнитьСведенияОбОтделенииПФРПоКоду, КодГосОргана", ДопПараметры.ИмяПроцедурыПоЗавершениюСозданияГосОргана, ДопПараметры.КодГосОргана);
			ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержку", ЭтотОбъект, ПараметрыВопроса);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			
		Иначе
			ПоказатьПредупреждение(, ОписаниеОшибки);
		КонецЕсли;
	Иначе
		Если ДопПараметры.ИмяПроцедурыПоЗавершениюСозданияГосОргана = "РаспечататьКвитанциюЗавершение" Тогда
			РаспечататьКвитанциюЗавершение();
		ИначеЕсли ДопПараметры.ИмяПроцедурыПоЗавершениюСозданияГосОргана = "РаспечататьПлатежноеПоручениеЗавершение" Тогда
			РаспечататьПлатежноеПоручениеЗавершение();
		ИначеЕсли ДопПараметры.ИмяПроцедурыПоЗавершениюСозданияГосОргана = "ПолучитьФайлКлиентБанка" Тогда
			ПолучитьФайлКлиентБанка();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьИнтернетПоддержку(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Оповещение = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержкуЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(Оповещение, ЭтотОбъект);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПодключитьИнтернетПоддержкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		
		Если ДополнительныеПараметры.Свойство("ВызовПослеПодключения") Тогда
			
			Если ДополнительныеПараметры.ВызовПослеПодключения = "ЗаполнитьСведенияОбОтделенииПФРПоКоду" Тогда
				
				ЗаполнитьСведенияОбОтделенииПФРПоКоду(,ДополнительныеПараметры.КодГосОргана);
				
				Если ДополнительныеПараметры.ИмяПроцедурыПоЗавершениюСозданияГосОргана = "РаспечататьКвитанциюЗавершение" Тогда
					РаспечататьКвитанциюЗавершение();
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьСведенияОбОтделенииПФРПоКоду(ОписаниеОшибки = "", КодНалоговогоОрганаПолучателя)
	
	РеквизитыОрганаПФР = ДанныеГосударственныхОрганов.РеквизитыНалоговогоОрганаПоКоду(КодНалоговогоОрганаПолучателя);
	
	Если ЗначениеЗаполнено(РеквизитыОрганаПФР.ОписаниеОшибки) Тогда
		ОписаниеОшибки = РеквизитыОрганаПФР.ОписаниеОшибки;
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(РеквизитыОрганаПФР.Ссылка) Тогда
		ДанныеГосударственныхОрганов.ОбновитьДанныеГосударственногоОргана(РеквизитыОрганаПФР);
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеПлатежныхРеквизитовФНС(Ответ, ДопПараметры) Экспорт
	Если ТипЗнч(Ответ) = Тип("Структура") Тогда
		Если ДопПараметры.ИмяПроцедурыПоЗавершениюСозданияГосОргана = "РаспечататьКвитанциюЗавершение" Тогда
			РаспечататьКвитанциюЗавершение();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ГосОрганСуществует(Организация, КодГосОргана)
	
	КодГосОргана = Организация.КодНалоговогоОрганаПолучателя;
	ГосОрган = ДанныеГосударственныхОрганов.ГосударственныйОрган(Перечисления.ВидыГосударственныхОрганов.НалоговыйОрган, КодГосОргана);
	
	Возврат ЗначениеЗаполнено(ГосОрган.Ссылка);
	
КонецФункции

&НаСервереБезКонтекста
Функция ВыгрузитьДокументВФайл(МассивОбъектов, ВидФайла)
	
	ТабДок = Новый ТабличныйДокумент;
	
	Если ВидФайла = "Квитанция" Тогда
		Для Каждого Объект Из МассивОбъектов Цикл
			ТабДокОбъекта = Документы.НачислениеНалогов.СформироватьКвитанцию(Объект);
			ТабДокОбъекта.Область().СоздатьФорматСтрок();
			Если ТабДок = Неопределено Тогда
				ТабДок = ТабДокОбъекта;
			Иначе
				ТабДок.Вывести(ТабДокОбъекта);
			КонецЕсли;
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЦикла;
		
	ИначеЕсли ВидФайла = "ПлатежноеПоручение" Тогда
		ОбъектыПечати = Новый СписокЗначений;
		ТабДок = Документы.ПлатежноеПоручение.ПечатнаяФорма(МассивОбъектов, ОбъектыПечати);
	КонецЕсли;
	
	СтруктураПечати = Новый Структура ("АдресФайла, НаименованиеФайла");
	
	Если ТабДок = Неопределено Тогда
		Возврат СтруктураПечати;
	Конецесли;
	
	Каталог = КаталогВременныхФайлов()+ОбщегоНазначения.ЗначениеРазделителяСеанса()+"\";
	
	ПроверкаКаталога = Новый Файл(Каталог);
	Если НЕ ПроверкаКаталога.Существует() Тогда
		СоздатьКаталог(Каталог);
	КонецЕсли;
	ПризнакОшибки = Ложь;
	РасширениеФайла = ".pdf" ;
	НаименованиеФайла = Строка(?(МассивОбъектов.Количество() > 0,МассивОбъектов[0], НСтр("ru='Результат'")));
	НаименованиеФайла = ?(СтрДлина(НаименованиеФайла)+СтрДлина(РасширениеФайла)>64, Лев(НаименованиеФайла,64 - СтрДлина(РасширениеФайла)),НаименованиеФайла);
	НаименованиеФайла = СтрЗаменить(НаименованиеФайла, ":","_");
	
	ПолноеИмяФайла = Каталог + НаименованиеФайла + РасширениеФайла;
	ПолноеИмяФайла = СтрЗаменить(ПолноеИмяФайла, """","");
	
	Попытка
		ТабДок.Записать(ПолноеИмяФайла, ТипФайлаТабличногоДокумента.PDF);
		
	Исключение
		ПризнакОшибки = Истина;
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Ошибка сохранения файла на сервере'"),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru= 'При сохранении файла на сервере в области данных %1 произошла ошибка:
						|%2'"),
				ОбщегоНазначения.ЗначениеРазделителяСеанса(),
				ОписаниеОшибки()),
			РежимТранзакцииЗаписиЖурналаРегистрации.Независимая);
		
		Возврат СтруктураПечати;
		
	Конецпопытки;
	ДанныеФайла = Новый ДвоичныеДанные(ПолноеИмяФайла);
	АдресФайла = ПоместитьВоВременноеХранилище(ДанныеФайла, Новый УникальныйИдентификатор);
	УдалитьФайлы(ПолноеИмяФайла);
	УдалитьФайлы(Каталог);
	СтруктураПечати.АдресФайла = АдресФайла;
	СтруктураПечати.НаименованиеФайла = НаименованиеФайла+РасширениеФайла;
	
	Возврат СтруктураПечати;
	
КонецФункции

