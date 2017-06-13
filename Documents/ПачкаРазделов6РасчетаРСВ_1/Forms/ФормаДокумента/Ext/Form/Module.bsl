﻿&НаКлиенте
Перем НомерТекущейСтроиЗаписиОСтаже;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	ЗаписиОСтажеТекст = НСтр("ru = 'Записи о стаже'");
	Если Параметры.Ключ.Пустая() Тогда
		ПриПолученииДанныхНаСервере(РеквизитФормыВЗначение("Объект", Тип("ДокументОбъект.ПачкаРазделов6РасчетаРСВ_1")));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ОбъектВДанныеФормы(ТекущийОбъект);
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "РедактированиеДанныхСЗВ6ПоСотруднику" Тогда
		ПриИзмененииДанныхДокументаПоСотруднику(Параметр.АдресВоВременномХранилище);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	ТекущийОбъект = РеквизитФормыВЗначение("Объект", Тип("ДокументОбъект.ПачкаРазделов6РасчетаРСВ_1"));
	
	Отказ = Не ТекущийОбъект.ПроверитьЗаполнение();
	
	ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(ПроверяемыеРеквизиты, "Объект");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОтчетныйПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	Отказ = Ложь;
	
	Если Отказ Тогда 
		ПредупреждениеОНедопустимомОтчетномПериоде();;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура КорректируемыйПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	Отказ = Ложь;
	
	Если Отказ Тогда 
		ПредупреждениеОНедопустимомОтчетномПериоде();;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТипСведенийПриИзменении(Элемент)
	ТипСведенийСЗВПриИзмененииНаСервере();	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		ЭтотОбъект,
		"Объект.Комментарий"
	);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Если Копирование Тогда
		Отказ = Истина;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередУдалением(Элемент, Отказ)
	ПерсонифицированныйУчетКлиентСервер.ДокументыРедактированияСтажаСотрудникиПередУдалением(Элементы.Сотрудники.ВыделенныеСтроки, Объект.Сотрудники, Объект.ЗаписиОСтаже);	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элементы.Сотрудники.ТекущийЭлемент = Элементы.СотрудникиФизическоеЛицо
		И Не ЗначениеЗаполнено(Элементы.Сотрудники.ТекущиеДанные.Сотрудник) Тогда
		
		Возврат;
	КонецЕсли;	
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура ЗаписатьНаДиск(Команда)
	ДанныеФайла = ПолучитьДанныеФайлаНаСервере(Объект.Ссылка, УникальныйИдентификатор);
	ПрисоединенныеФайлыКлиент.СохранитьФайлКак(ДанныеФайла);
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки (НА СЕРВЕРЕ БЕЗ КОНТЕКСТА)
	
&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	Если Не ТаблицаДополнена Тогда 
		ИменаТаблиц = Новый Массив;
		ИменаТаблиц.Добавить("Сотрудники");
		
		ТаблицаДополнена = Истина;
	КонецЕсли;	

	
	ПериодСтрока = ПерсонифицированныйУчетКлиентСервер.ПредставлениеОтчетногоПериода(Объект.ОтчетныйПериод);
	
	КорректируемыйПериодСтрока = ПерсонифицированныйУчетКлиентСервер.ПредставлениеОтчетногоПериода(Объект.КорректируемыйПериод);

	ОбъектВДанныеФормы(ТекущийОбъект);
	
	УстановитьДоступностьПолейСтажаЗаработка(ЭтаФорма);
	
	УстановитьВидимостьПолейТаблицыСотрудники();
КонецПроцедуры

&НаСервере
Процедура ОбъектВДанныеФормы(ТекущийОбъект)
	СтрокиПоСотрудникам = Новый Соответствие;
	
	Для Каждого СтрокаСотрудник Из Объект.Сотрудники Цикл
		СтрокиПоСотрудникам.Вставить(СтрокаСотрудник.Сотрудник, СтрокаСотрудник);	
	КонецЦикла;	
	
	Для Каждого СтрокаЗаработокДокумента Из ТекущийОбъект.СведенияОЗаработке Цикл 		
		СтрокаСотрудник = СтрокиПоСотрудникам[СтрокаЗаработокДокумента.Сотрудник];
		
		Если СтрокаСотрудник <> Неопределено
			И СтрокаЗаработокДокумента.Месяц <> 0 Тогда
			
			СтрокаСотрудник.Заработок = СтрокаСотрудник.Заработок + СтрокаЗаработокДокумента.Заработок;
			СтрокаСотрудник.ОблагаетсяВзносамиДоПредельнойВеличины = СтрокаСотрудник.ОблагаетсяВзносамиДоПредельнойВеличины + СтрокаЗаработокДокумента.ОблагаетсяВзносамиДоПредельнойВеличины;
			СтрокаСотрудник.ОблагаетсяВзносамиСвышеПредельнойВеличины = СтрокаСотрудник.ОблагаетсяВзносамиСвышеПредельнойВеличины + СтрокаЗаработокДокумента.ОблагаетсяВзносамиСвышеПредельнойВеличины;
			СтрокаСотрудник.ПоДоговорамГПХДоПредельнойВеличины = СтрокаСотрудник.ПоДоговорамГПХДоПредельнойВеличины + СтрокаЗаработокДокумента.ПоДоговорамГПХДоПредельнойВеличины;
		КонецЕсли;	
	КонецЦикла;	
	
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьПолейСтажаЗаработка(Форма)	
	Форма.Элементы.РегистрационныйНомерПФРвКорректируемыйПериод.Доступность = Форма.Объект.ТипСведенийСЗВ <> ПредопределенноеЗначение("Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ") 
КонецПроцедуры	

&НаСервереБезКонтекста
Функция ПолучитьДанныеФайлаНаСервере(Ссылка, УникальныйИдентификатор)
	
КонецФункции	

&НаСервере
Процедура ТипСведенийСЗВПриИзмененииНаСервере()
	
	Если Объект.ТипСведенийСЗВ <> Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ Тогда
		Объект.КорректируемыйПериод = '20140101';
		КорректируемыйПериодСтрока = ПерсонифицированныйУчетКлиентСервер.ПредставлениеОтчетногоПериода(Объект.КорректируемыйПериод);
	КонецЕсли;
	
	УстановитьДоступностьПолейСтажаЗаработка(ЭтаФорма);
	
	Если Объект.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ОТМЕНЯЮЩАЯ Тогда
		
		Объект.ЗаписиОСтаже.Очистить();
		Объект.СведенияОЗаработке.Очистить();
		Объект.СведенияОЗаработкеНаВредныхИТяжелыхРаботах.Очистить();
		
		Для Каждого СтрокаСотрудник Из Объект.Сотрудники Цикл
			СтрокаСотрудник.НачисленоСтраховая = 0;		
		КонецЦикла;	
	КонецЕсли;	

	УстановитьВидимостьПолейТаблицыСотрудники();
КонецПроцедуры

&НаСервере
Процедура  УстановитьВидимостьПолейТаблицыСотрудники()
	Если Объект.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ Тогда
		Элементы.СотрудникиНачисленоСтраховая.Видимость = Истина;
		Элементы.СотрудникиДоначисленоСтраховая.Видимость = Ложь;
		Элементы.СотрудникиЗаработок.Видимость = Истина;
		Элементы.СотрудникиОблагаетсяВзносамиДоПредельнойВеличины.Видимость = Истина;
		Элементы.СотрудникиОблагаетсяВзносамиСвышеПредельнойВеличины.Видимость = Истина;
	ИначеЕсли Объект.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.КОРРЕКТИРУЮЩАЯ Тогда
		Элементы.СотрудникиНачисленоСтраховая.Видимость = Истина;
		Элементы.СотрудникиДоначисленоСтраховая.Видимость = Истина;
		Элементы.СотрудникиЗаработок.Видимость = Истина;
		Элементы.СотрудникиОблагаетсяВзносамиДоПредельнойВеличины.Видимость = Истина;
		Элементы.СотрудникиОблагаетсяВзносамиСвышеПредельнойВеличины.Видимость = Истина;
	ИначеЕсли Объект.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ОТМЕНЯЮЩАЯ Тогда
		Элементы.СотрудникиНачисленоСтраховая.Видимость = Ложь;
		Элементы.СотрудникиДоначисленоСтраховая.Видимость = Истина;
		Элементы.СотрудникиЗаработок.Видимость = Ложь;
		Элементы.СотрудникиОблагаетсяВзносамиДоПредельнойВеличины.Видимость = Ложь;
		Элементы.СотрудникиОблагаетсяВзносамиСвышеПредельнойВеличины.Видимость = Ложь;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОписаниеЭлементовСИндикациейОшибок() Экспорт
	ОписаниеЭлементовИндикацииОшибок = Новый Соответствие;	
	Возврат ОписаниеЭлементовИндикацииОшибок;
КонецФункции	

&НаКлиенте
Процедура ПриИзмененииДанныхДокументаПоСотруднику(АдресВоВременномХранилище)
	ДанныеТекущегоДокументаПоСотрудникуВДанныеФормы(АдресВоВременномХранилище);
КонецПроцедуры	

&НаСервере
Процедура ДанныеТекущегоДокументаПоСотрудникуВДанныеФормы(АдресВоВременномХранилище)
	
	ДанныеШапкиДокумента = Объект;
	
	ДанныеТекущегоДокумента = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	
	Если ДанныеТекущегоДокумента = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеТекущейСтрокиПоСотруднику = Неопределено;
	НайденныеСтроки = Объект.Сотрудники.НайтиСтроки(Новый Структура("ИсходныйНомерСтроки", ДанныеТекущегоДокумента.ИсходныйНомерСтроки));
		
	Если НайденныеСтроки.Количество() > 0 Тогда
		ДанныеТекущейСтрокиПоСотруднику = НайденныеСтроки[0];
		
		Если ДанныеТекущейСтрокиПоСотруднику.Сотрудник <> ДанныеТекущегоДокумента.Сотрудник Тогда
			ДанныеТекущейСтрокиПоСотруднику = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеТекущейСтрокиПоСотруднику = Неопределено  Тогда
		
		ВызватьИсключение НСтр("ru = 'В текущем документе не найдены данные по редактируемому сотруднику.'");
	КонецЕсли;
	
	ДанныеТекущейСтрокиПоСотруднику = Объект.Сотрудники.НайтиПоИдентификатору(Элементы.Сотрудники.ТекущаяСтрока);
		
	ЗаполнитьЗначенияСвойств(ДанныеТекущейСтрокиПоСотруднику, ДанныеТекущегоДокумента);
		
	СтруктураПоиска = Новый Структура("Сотрудник", ДанныеТекущейСтрокиПоСотруднику.Сотрудник);
	
	СтрокиЗаработка = Объект.СведенияОЗаработке.НайтиСтроки(СтруктураПоиска);
	
	СуществущиеСтрокиЗаработка = Новый Массив;
	
	ДанныеТекущейСтрокиПоСотруднику.Заработок = 0;
	ДанныеТекущейСтрокиПоСотруднику.ОблагаетсяВзносамиДоПредельнойВеличины = 0;
	ДанныеТекущейСтрокиПоСотруднику.ОблагаетсяВзносамиСвышеПредельнойВеличины = 0;
	ДанныеТекущейСтрокиПоСотруднику.ПоДоговорамГПХДоПредельнойВеличины = 0;
	
	Для Каждого СтрокаЗаработок Из ДанныеТекущегоДокумента.СведенияОЗаработке Цикл
		СтрокаЗаработокОбъекта = Объект.СведенияОЗаработке.НайтиПоИдентификатору(СтрокаЗаработок.ИдентификаторИсходнойСтроки);
		
		Если СтрокаЗаработокОбъекта = Неопределено Тогда
			СтрокаЗаработокОбъекта = Объект.СведенияОЗаработке.Добавить();
			СтрокаЗаработокОбъекта.Сотрудник = ДанныеТекущейСтрокиПоСотруднику.Сотрудник;
		Иначе
			СуществущиеСтрокиЗаработка.Добавить(СтрокаЗаработокОбъекта.ПолучитьИдентификатор());
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СтрокаЗаработокОбъекта, СтрокаЗаработок);
		
		Если СтрокаЗаработокОбъекта.Месяц <> 0 Тогда
			ДанныеТекущейСтрокиПоСотруднику.Заработок = ДанныеТекущейСтрокиПоСотруднику.Заработок + СтрокаЗаработок.Заработок;
			ДанныеТекущейСтрокиПоСотруднику.ОблагаетсяВзносамиДоПредельнойВеличины = ДанныеТекущейСтрокиПоСотруднику.ОблагаетсяВзносамиДоПредельнойВеличины + СтрокаЗаработок.ОблагаетсяВзносамиДоПредельнойВеличины;
			ДанныеТекущейСтрокиПоСотруднику.ОблагаетсяВзносамиСвышеПредельнойВеличины = ДанныеТекущейСтрокиПоСотруднику.ОблагаетсяВзносамиСвышеПредельнойВеличины + СтрокаЗаработок.ОблагаетсяВзносамиСвышеПредельнойВеличины;
			ДанныеТекущейСтрокиПоСотруднику.ПоДоговорамГПХДоПредельнойВеличины = ДанныеТекущейСтрокиПоСотруднику.ПоДоговорамГПХДоПредельнойВеличины + СтрокаЗаработок.ПоДоговорамГПХДоПредельнойВеличины;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаЗаработокСотрудника Из СтрокиЗаработка Цикл
		Если СуществущиеСтрокиЗаработка.Найти(СтрокаЗаработокСотрудника.ПолучитьИдентификатор()) = Неопределено Тогда
			Объект.СведенияОЗаработке.Удалить(Объект.СведенияОЗаработке.Индекс(СтрокаЗаработокСотрудника));
		КонецЕсли;
	КонецЦикла;
	
	СтрокиСтажа = Объект.ЗаписиОСтаже.НайтиСтроки(СтруктураПоиска);
	
	СуществущиеСтрокиСтажа = Новый Массив;
	
	СтрокиСтажаПоСотруднику = Новый Массив;
	Для Каждого СтрокаСтаж Из ДанныеТекущегоДокумента.ЗаписиОСтаже Цикл
		СтрокаСтажОбъекта = Объект.ЗаписиОСтаже.НайтиПоИдентификатору(СтрокаСтаж.ИдентификаторИсходнойСтроки);
		
		Если СтрокаСтажОбъекта = Неопределено Тогда
			СтрокаСтажОбъекта = Объект.ЗаписиОСтаже.Добавить();
			СтрокаСтажОбъекта.Сотрудник = ДанныеТекущейСтрокиПоСотруднику.Сотрудник;
		Иначе
			СуществущиеСтрокиСтажа.Добавить(СтрокаСтажОбъекта.ПолучитьИдентификатор());
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СтрокаСтажОбъекта, СтрокаСтаж);
		
		СтрокиСтажаПоСотруднику.Добавить(СтрокаСтажОбъекта);
	КонецЦикла;
	
	ПерсонифицированныйУчетКлиентСервер.ВыполнитьНумерациюЗаписейОСтаже(СтрокиСтажаПоСотруднику);
	
	Для Каждого СтрокаСтажСотрудника Из СтрокиСтажа Цикл
		Если СуществущиеСтрокиСтажа.Найти(СтрокаСтажСотрудника.ПолучитьИдентификатор()) = Неопределено Тогда
			Объект.ЗаписиОСтаже.Удалить(Объект.ЗаписиОСтаже.Индекс(СтрокаСтажСотрудника));
		КонецЕсли;
	КонецЦикла;
	
	СтрокиВредногоЗаработка = Объект.СведенияОЗаработкеНаВредныхИТяжелыхРаботах.НайтиСтроки(СтруктураПоиска);
	
	СуществущиеСтрокиВредногоЗаработка = Новый Массив;
	
	СтрокиВредногоЗаработкаПоСотруднику = Новый Массив;
	Для Каждого СтрокаВредныйЗаработок Из ДанныеТекущегоДокумента.СведенияОЗаработкеНаВредныхИТяжелыхРаботах Цикл
		СтрокаВредныйЗаработокОбъекта = Объект.СведенияОЗаработкеНаВредныхИТяжелыхРаботах.НайтиПоИдентификатору(СтрокаВредныйЗаработок.ИдентификаторИсходнойСтроки);
		
		Если СтрокаВредныйЗаработокОбъекта = Неопределено Тогда
			СтрокаВредныйЗаработокОбъекта = Объект.СведенияОЗаработкеНаВредныхИТяжелыхРаботах.Добавить();
			СтрокаВредныйЗаработокОбъекта.Сотрудник = ДанныеТекущейСтрокиПоСотруднику.Сотрудник;
		Иначе
			СуществущиеСтрокиВредногоЗаработка.Добавить(СтрокаВредныйЗаработокОбъекта.ПолучитьИдентификатор());
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(СтрокаВредныйЗаработокОбъекта, СтрокаВредныйЗаработок);
		
	КонецЦикла;
			
	Для Каждого СтрокаВредныйЗаработокСотрудника Из СтрокиВредногоЗаработка Цикл
		Если СуществущиеСтрокиВредногоЗаработка.Найти(СтрокаВредныйЗаработокСотрудника.ПолучитьИдентификатор()) = Неопределено Тогда
			Объект.СведенияОЗаработкеНаВредныхИТяжелыхРаботах.Удалить(Объект.СведенияОЗаработкеНаВредныхИТяжелыхРаботах.Индекс(СтрокаВредныйЗаработокСотрудника));
		КонецЕсли;
	КонецЦикла;

	Если ДанныеТекущегоДокумента.Модифицированность Тогда
		Модифицированность = Истина;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПредупреждениеОНедопустимомОтчетномПериоде()
	Текст = НСтр("ru = 'Форма предоставляется, начиная с 2014 г. За предыдущие периоды предоставляется формы СЗВ-1(2, 4).'");
	
	ПоказатьПредупреждение(,Текст);
КонецПроцедуры	


