﻿#Область ОбработчикиСлужебные

&НаКлиенте
// Процедура изменяет текущую строку ТЧ Сотрудники
//
Процедура ИзменитьТекущегоСотрудника()
	
	Элементы.Сотрудники.ТекущаяСтрока = ТекущийСотрудник;
	
КонецПроцедуры // ИзменитьТекущегоСотрудника()

&НаСервере
// Функция вызывает функцию НайтиНачисленияУдержанияСотрудника объекта.
//
Функция НайтиНачисленияУдержанияСотрудникаСервер(СтруктураОтбора, Налог = Ложь)	
	
	Документ = РеквизитФормыВЗначение("Объект");
	РезультатПоиска = Документ.НайтиНачисленияУдержанияСотрудника(СтруктураОтбора, Налог);
	ЗначениеВРеквизитФормы(Документ, "Объект");
	
	Возврат РезультатПоиска;
	
КонецФункции

&НаСервереБезКонтекста
// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
Функция ПолучитьДанныеДатаПриИзменении(ДокументСсылка, ДатаНовая, ДатаПередИзменением)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("РазностьДат", УправлениеНебольшойФирмойСервер.ПроверитьНомерДокумента(ДокументСсылка, ДатаНовая, ДатаПередИзменением));
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеДатаПриИзменении()

&НаСервереБезКонтекста
// Получает набор данных с сервера для процедуры ДоговорПриИзменении.
//
Функция ПолучитьДанныеОрганизацияПриИзменении(Организация)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("Компания", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Организация));
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеОрганизацияПриИзменении()

&НаСервере
// Заполняет значения ТЧ Сотрудники.
//
Процедура ЗаполнитьЗначения()
	
	Если Объект.Сотрудники.Количество() = 0 ИЛИ Объект.ВидОперации = Перечисления.ВидыОперацийКадровоеПеремещение.ИзменениеСпособаОплаты Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого СтрокаТЧ Из Объект.Сотрудники Цикл
		
		СтруктураСотрудник = Новый Структура;
		СтруктураСотрудник.Вставить("Период", СтрокаТЧ.Период - 1);
		СтруктураСотрудник.Вставить("Сотрудник", СтрокаТЧ.Сотрудник);
		СтруктураСотрудник.Вставить("Организация", Объект.Организация);
		
		ПолучитьДанныеСотрудника(СтруктураСотрудник);
		
		СтрокаТЧ.ПрежнееПодразделение = СтруктураСотрудник.СтруктурнаяЕдиница;
		СтрокаТЧ.ПрежняяДолжность = СтруктураСотрудник.Должность;
		СтрокаТЧ.ПрежнееКоличествоЗанимаемыхСтавок = СтруктураСотрудник.ЗанимаемыхСтавок;
		СтрокаТЧ.ПрежнийГрафикРаботы = СтруктураСотрудник.ГрафикРаботы;
		
	КонецЦикла;
	
КонецПроцедуры // 

&НаСервере
// Заполняет значения ТЧ Сотрудники.
//
Процедура ЗаполнитьЗначенияПоВсемСотрудникам()	
	
	Для каждого СтрокаТЧ Из Объект.Сотрудники Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТЧ.ПрежнееПодразделение)
				ИЛИ ЗначениеЗаполнено(СтрокаТЧ.ПрежняяДолжность) Тогда
		
			СтруктураСотрудник = Новый Структура;
			СтруктураСотрудник.Вставить("Период", СтрокаТЧ.Период - 1);
			СтруктураСотрудник.Вставить("Сотрудник", СтрокаТЧ.Сотрудник);
			СтруктураСотрудник.Вставить("Организация", Объект.Организация);
			
			ПолучитьДанныеСотрудника(СтруктураСотрудник);
			
			СтрокаТЧ.ПрежнееПодразделение = СтруктураСотрудник.СтруктурнаяЕдиница;
			СтрокаТЧ.ПрежняяДолжность = СтруктураСотрудник.Должность;
			СтрокаТЧ.ПрежнееКоличествоЗанимаемыхСтавок = СтруктураСотрудник.ЗанимаемыхСтавок;
			СтрокаТЧ.ПрежнийГрафикРаботы = СтруктураСотрудник.ГрафикРаботы;
		
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // 

&НаСервереБезКонтекста
// Получает с сервера набор данных из РС Сотрудники.
//
Процедура ПолучитьДанныеСотрудника(СтруктураСотрудник)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СотрудникиСрезПоследних.СтруктурнаяЕдиница,
	|	СотрудникиСрезПоследних.Должность,
	|	СотрудникиСрезПоследних.ЗанимаемыхСтавок,
	|	СотрудникиСрезПоследних.ГрафикРаботы
	|ИЗ
	|	РегистрСведений.Сотрудники.СрезПоследних(
	|			&Период,
	|			Сотрудник = &Сотрудник
	|				И Организация = &Организация) КАК СотрудникиСрезПоследних");
	
	Запрос.УстановитьПараметр("Период", СтруктураСотрудник.Период);
	Запрос.УстановитьПараметр("Сотрудник", СтруктураСотрудник.Сотрудник);
	Запрос.УстановитьПараметр("Организация", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(СтруктураСотрудник.Организация));
	
	СтруктураСотрудник.Вставить("СтруктурнаяЕдиница");
	СтруктураСотрудник.Вставить("Должность");
	СтруктураСотрудник.Вставить("ЗанимаемыхСтавок", 1);
	СтруктураСотрудник.Вставить("ГрафикРаботы");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(СтруктураСотрудник, Выборка);
	КонецЦикла;
	
КонецПроцедуры // ПолучитьДанныеДатаПриИзменении()

&НаСервере
// Процедура заполняет список выбора управляющего поля Текущий сотрудник
//
Процедура ЗаполнитьСписокВыбораТекущихСотрудников()
	
	Элементы.ТекущийСотрудникНачисленияУдержания.СписокВыбора.Очистить();
	Элементы.ТекущийСотрудникНалоги.СписокВыбора.Очистить();
	Для каждого СтрокаСотрудник Из Объект.Сотрудники Цикл
		
		ПредставлениеСтроки = Строка(СтрокаСотрудник.Сотрудник) + НСтр("ru =', ТН: '") + Строка(СтрокаСотрудник.Сотрудник.Код);
		Элементы.ТекущийСотрудникНачисленияУдержания.СписокВыбора.Добавить(СтрокаСотрудник.ПолучитьИдентификатор(), ПредставлениеСтроки);
		Элементы.ТекущийСотрудникНалоги.СписокВыбора.Добавить(СтрокаСотрудник.ПолучитьИдентификатор(), ПредставлениеСтроки);
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьСписокВыбораТекущихСотрудников()

&НаСервере
// Процедура устанавливает доступность элементов формы на клиенте.
//
// Параметры:
//  Нет.
//
Процедура УстановитьВидимостьНаСервере()
	
	ЭтоКадровоеПеремещениеОклад = (Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийКадровоеПеремещение.ПеремещениеИИзменениеСпособаОплаты"));
	
	Элементы.СотрудникиПрежнийГрафикРаботы.Видимость 	= ЭтоКадровоеПеремещениеОклад;
	Элементы.СотрудникиПрежняяДолжность.Видимость 		= ЭтоКадровоеПеремещениеОклад;
	Элементы.СотрудникиПрежнееПодразделение.Видимость	= ЭтоКадровоеПеремещениеОклад;
	Элементы.СотрудникиГрафикРаботы.Видимость 			= ЭтоКадровоеПеремещениеОклад;
	Элементы.СотрудникиДолжность.Видимость 				= ЭтоКадровоеПеремещениеОклад;
	Элементы.СотрудникиСтруктурнаяЕдиница.Видимость 	= ЭтоКадровоеПеремещениеОклад;
	
	Если ЭтоКадровоеПеремещениеОклад Тогда
		
		Элементы.СотрудникиПрежнееКоличествоЗанимаемыхСтавок.Видимость	= ВестиШтатноеРасписание;
		Элементы.СотрудникиЗанимаемыхСтавок.Видимость					= ВестиШтатноеРасписание;
		
		Элементы.СотрудникиСтруктурнаяЕдиница.АвтоВыборНезаполненного 	= Истина;
		Элементы.СотрудникиДолжность.АвтоВыборНезаполненного 			= Истина;
		Элементы.СотрудникиЗанимаемыхСтавок.АвтоВыборНезаполненного 	= Истина;
		Элементы.СотрудникиСтруктурнаяЕдиница.АвтоОтметкаНезаполненного = Истина;
		Элементы.СотрудникиДолжность.АвтоОтметкаНезаполненного 			= Истина;
		Элементы.СотрудникиЗанимаемыхСтавок.АвтоОтметкаНезаполненного 	= Истина;
		
	Иначе
		
		Элементы.СотрудникиПрежнееКоличествоЗанимаемыхСтавок.Видимость	= Ложь;
		Элементы.СотрудникиЗанимаемыхСтавок.Видимость					= Ложь;
		
	конецЕсли;
	
КонецПроцедуры // УстановитьВидимостьНаСервере()

&НаСервере
// Процедура инициализирует управление видимость 
// и заполние вычисляемых значений на сервере
//
Процедура ОбработатьСобытиеНаСервере(УстановитьВидимость = Истина, ЗаполнитьЗначения = Истина)
	
	Если УстановитьВидимость Тогда
		
		УстановитьВидимостьНаСервере();
		
	КонецЕсли;
	
	Если ЗаполнитьЗначения Тогда
		
		ЗаполнитьЗначения();
		
	КонецЕсли;
	
КонецПроцедуры //ОбработатьСобытиеНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере формы.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДата();
	КонецЕсли;
	
	Компания = УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Объект.Организация);
	ИмяТабличнойЧасти = "Сотрудники";
	ВалютаПоУмолчанию = Константы.НациональнаяВалюта.Получить();
	
	ВестиШтатноеРасписание = Константы.ФункциональнаяОпцияВестиШтатноеРасписание.Получить();
	
	ОбработатьСобытиеНаСервере();
	
	Если НЕ Константы.ФункциональнаяОпцияИспользоватьСовместительство.Получить() Тогда
		
		Если Элементы.Найти("СотрудникиСотрудникКод") <> Неопределено Тогда
			
			Элементы.СотрудникиСотрудникКод.Видимость = Ложь;
			
		КонецЕсли;
		
	КонецЕсли; 
	
	Пользователь = Пользователи.ТекущийПользователь();
	
	ЗначениеНастройки = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь, "ОсновноеПодразделение");
	ОсновноеПодразделение = ?(ЗначениеЗаполнено(ЗначениеНастройки), ЗначениеНастройки, Справочники.СтруктурныеЕдиницы.ОсновноеПодразделение);
	
	Если НЕ Константы.ФункциональнаяОпцияУчетПоНесколькимПодразделениям.Получить() Тогда
		Элементы.СотрудникиПрежнееПодразделение.Видимость = Ложь;
	КОнецЕсли;
	
	УчетНалогов = ПолучитьФункциональнуюОпцию("ВестиУчетНалогаНаДоходыИВзносов");
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ТекущийСотрудникНалоги", "Видимость", УчетНалогов);
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаВажныеКоманды);
	// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры // ПриЧтенииНаСервере()

&НаСервере
// Процедура - обработчик события ПослеЗаписиНаСервере.
//
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ОбработатьСобытиеНаСервере();
	
КонецПроцедуры //ПослеЗаписиНаСервере()


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ИзменениеПоКадровомуУчету");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРеквизитовШапки

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода Дата.
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
Процедура ДатаПриИзменении(Элемент)
	
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ДатаПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода Организация.
// В процедуре осуществляется очистка номера документа,
// а также производится установка параметров функциональных опций формы.
// Переопределяет соответствующий параметр формы.
//
Процедура ОрганизацияПриИзменении(Элемент)

	// Обработка события изменения организации.
	Объект.Номер = "";
	СтруктураДанные = ПолучитьДанныеОрганизацияПриИзменении(Объект.Организация);
	Компания = СтруктураДанные.Компания;
	
КонецПроцедуры // ОрганизацияПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ввода ВидОперации.
// В процедуре осуществляется очистка номера документа,
// а также производится установка параметров функциональных опций формы.
// Переопределяет соответствующий параметр формы.
//
Процедура ВидОперацииПриИзменении(Элемент)
	
	ОбработатьСобытиеНаСервере(,Ложь);
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийКадровоеПеремещение.ПеремещениеИИзменениеСпособаОплаты") Тогда
	
		Для каждого СтрокаТЧ Из Объект.Сотрудники Цикл
			
			Если Не ЗначениеЗаполнено(СтрокаТЧ.ПрежнееПодразделение)
				ИЛИ ЗначениеЗаполнено(СтрокаТЧ.ПрежняяДолжность) Тогда
				
				ЗаполнитьЗначенияПоВсемСотрудникам();
				Прервать;
			
			КонецЕсли;
			
		КонецЦикла;
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события ПриСменеСтраницы поля СтраницыОсновная
//
Процедура СтраницыОсновнаяПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.СтраницаНачисленияУдержания
		ИЛИ ТекущаяСтраница = Элементы.СтраницаНалоги Тогда
		
		ЗаполнитьСписокВыбораТекущихСотрудников();
		
		ДанныеТекущейСтроки = Элементы.Сотрудники.ТекущиеДанные;
		
		Если ДанныеТекущейСтроки <> Неопределено Тогда
			
			ТекущийСотрудник = ДанныеТекущейСтроки.ПолучитьИдентификатор();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // СтраницыОсновнаяПриСменеСтраницы()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ТекущийСотрудникНачисленияУдержания
//
Процедура ТекущийСотрудникНачисленияУдержанияПриИзменении(Элемент)
	
	ИзменитьТекущегоСотрудника();
	
КонецПроцедуры // ТекущийСотрудникНачисленияУдержанияПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриИзменении поля ТекущийСотрудникНалоги
//
Процедура ТекущийСотрудникНалогиПриИзменении(Элемент)
	
	ИзменитьТекущегоСотрудника();
	
КонецПроцедуры // ТекущийСотрудникНалогиПриИзменении()

#КонецОбласти

#Область ОбработчикиТабличныхЧастей

&НаКлиенте
Процедура ЗаполнитьНачисленияУдержания(Команда)	
	
	СтрокаТабличнойЧасти = Элементы.Сотрудники.ТекущиеДанные;
	
	Если СтрокаТабличнойЧасти = Неопределено Тогда
	
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не выбрана строка табличной части ""Сотрудники""!'");
		Сообщение.Сообщить();	
		Возврат;
		
	КонецЕсли;  
	
	Если Объект.НачисленияУдержания.НайтиСтроки(Новый Структура("КлючСвязи", СтрокаТабличнойЧасти.КлючСвязи)).Количество() > 0 Тогда
		Ответ = Неопределено;

		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьНачисленияУдержанияЗавершение", ЭтотОбъект, Новый Структура("СтрокаТабличнойЧасти", СтрокаТабличнойЧасти)), НСтр("ru = 'Табличная часть ""Начисления и удержания"" будет очищена! Продолжить выполнение операции?'"), РежимДиалогаВопрос.ДаНет, 0);
        Возврат; 
	КонецЕсли;
	
	ЗаполнитьНачисленияУдержанияФрагмент(СтрокаТабличнойЧасти);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНачисленияУдержанияЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    СтрокаТабличнойЧасти = ДополнительныеПараметры.СтрокаТабличнойЧасти;
    
    
    Ответ = Результат;
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли; 
    
    ЗаполнитьНачисленияУдержанияФрагмент(СтрокаТабличнойЧасти);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНачисленияУдержанияФрагмент(Знач СтрокаТабличнойЧасти)
    
    Перем НоваяСтрока, РезультатПоиска, СтрокаПоиска, СтрОтбора, СтруктураОтбора;
    
    УправлениеНебольшойФирмойКлиент.УдалитьСтрокиПодчиненнойТабличнойЧасти(ЭтаФорма, "НачисленияУдержания");
    
    СтруктураОтбора = Новый Структура;
    СтруктураОтбора.Вставить("Сотрудник", 	СтрокаТабличнойЧасти.Сотрудник);
    СтруктураОтбора.Вставить("Организация", Объект.Организация);
    СтруктураОтбора.Вставить("Дата", 		СтрокаТабличнойЧасти.Период);		
    РезультатПоиска = НайтиНачисленияУдержанияСотрудникаСервер(СтруктураОтбора);
    
    Для каждого СтрокаПоиска Из РезультатПоиска Цикл
        НоваяСтрока 						= Объект.НачисленияУдержания.Добавить();
        НоваяСтрока.ВидНачисленияУдержания 	= СтрокаПоиска.ВидНачисленияУдержания;		
        НоваяСтрока.Сумма 					= СтрокаПоиска.Сумма;
        НоваяСтрока.Валюта 					= СтрокаПоиска.Валюта;
        НоваяСтрока.СчетЗатрат			 	= СтрокаПоиска.СчетЗатрат;
        НоваяСтрока.Актуальность			= СтрокаПоиска.Актуальность;
        НоваяСтрока.КлючСвязи 				= СтрокаТабличнойЧасти.КлючСвязи;
    КонецЦикла;	
    
    СтрОтбора = Новый ФиксированнаяСтруктура("КлючСвязи", СтрокаТабличнойЧасти.КлючСвязи);
    Элементы.НачисленияУдержания.ОтборСтрок 	= СтрОтбора;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНалогиНаДоходы(Команда)	
	
	СтрокаТабличнойЧасти = Элементы.Сотрудники.ТекущиеДанные;
	
	Если СтрокаТабличнойЧасти = Неопределено Тогда
	
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Не выбрана строка табличной части ""Сотрудники""!'");
		Сообщение.Сообщить();	
		Возврат;
		
	КонецЕсли;  
	
	Если Объект.НалогиНаДоходы.НайтиСтроки(Новый Структура("КлючСвязи", СтрокаТабличнойЧасти.КлючСвязи)).Количество() > 0 Тогда
		Ответ = Неопределено;

		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьНалогиНаДоходыЗавершение", ЭтотОбъект, Новый Структура("СтрокаТабличнойЧасти", СтрокаТабличнойЧасти)), НСтр("ru = 'Табличная часть ""Налоги на доходы"" будет очищена! Продолжить выполнение операции?'"), РежимДиалогаВопрос.ДаНет, 0);
        Возврат; 
	КонецЕсли;
	
	ЗаполнитьНалогиНаДоходыФрагмент(СтрокаТабличнойЧасти);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНалогиНаДоходыЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    СтрокаТабличнойЧасти = ДополнительныеПараметры.СтрокаТабличнойЧасти;
    
    
    Ответ = Результат;
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли; 
    
    ЗаполнитьНалогиНаДоходыФрагмент(СтрокаТабличнойЧасти);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНалогиНаДоходыФрагмент(Знач СтрокаТабличнойЧасти)
    
    Перем НоваяСтрока, РезультатПоиска, СтрокаПоиска, СтрОтбора, СтруктураОтбора;
    
    УправлениеНебольшойФирмойКлиент.УдалитьСтрокиПодчиненнойТабличнойЧасти(ЭтаФорма, "НалогиНаДоходы");
    
    СтруктураОтбора = Новый Структура;
    СтруктураОтбора.Вставить("Сотрудник", 	СтрокаТабличнойЧасти.Сотрудник);
    СтруктураОтбора.Вставить("Организация", Объект.Организация);
    СтруктураОтбора.Вставить("Дата", 		СтрокаТабличнойЧасти.Период);		
    РезультатПоиска = НайтиНачисленияУдержанияСотрудникаСервер(СтруктураОтбора, Истина);
    
    Для каждого СтрокаПоиска Из РезультатПоиска Цикл
        НоваяСтрока 						= Объект.НалогиНаДоходы.Добавить();
        НоваяСтрока.ВидНачисленияУдержания 	= СтрокаПоиска.ВидНачисленияУдержания;		
        НоваяСтрока.Валюта 					= СтрокаПоиска.Валюта;
        НоваяСтрока.Актуальность			= СтрокаПоиска.Актуальность;
        НоваяСтрока.КлючСвязи 				= СтрокаТабличнойЧасти.КлючСвязи;
    КонецЦикла;	
    
    СтрОтбора = Новый ФиксированнаяСтруктура("КлючСвязи", СтрокаТабличнойЧасти.КлючСвязи);
    Элементы.НалогиНаДоходы.ОтборСтрок 	= СтрОтбора;

КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события ПриАктивизации строки табличной части Сотрудники.
//
Процедура СотрудникиПриАктивизацииСтроки(Элемент)
		
	УправлениеНебольшойФирмойКлиент.УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ЭтаФорма, "НачисленияУдержания");
	УправлениеНебольшойФирмойКлиент.УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ЭтаФорма, "НалогиНаДоходы");
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события ПриНачалеРедактирования табличной части Сотрудники.
//
Процедура СотрудникиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда

		УправлениеНебольшойФирмойКлиент.ДобавитьКлючСвязиВСтрокуТабличнойЧасти(ЭтаФорма);
		УправлениеНебольшойФирмойКлиент.УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ЭтаФорма, "НачисленияУдержания");
		УправлениеНебольшойФирмойКлиент.УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ЭтаФорма, "НалогиНаДоходы");
		
		СтрокаТабличнойЧасти = Элементы.Сотрудники.ТекущиеДанные;
		СтрокаТабличнойЧасти.СтруктурнаяЕдиница = ОсновноеПодразделение;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события ПередУдалением табличной части Сотрудники.
//
Процедура СотрудникиПередУдалением(Элемент, Отказ)

	УправлениеНебольшойФирмойКлиент.УдалитьСтрокиПодчиненнойТабличнойЧасти(ЭтаФорма, "НачисленияУдержания");
	УправлениеНебольшойФирмойКлиент.УдалитьСтрокиПодчиненнойТабличнойЧасти(ЭтаФорма, "НалогиНаДоходы");

КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события ПриИзменении Сотрудник табличной части Сотрудники.
//
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	ТекущиеДанные.Период = ТекущаяДата();
	
	Если Объект.ВидОперации <> ПредопределенноеЗначение("Перечисление.ВидыОперацийКадровоеПеремещение.ПеремещениеИИзменениеСпособаОплаты") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураСотрудник = Новый Структура();
	СтруктураСотрудник.Вставить("Сотрудник", ТекущиеДанные.Сотрудник);
	СтруктураСотрудник.Вставить("Период", ТекущиеДанные.Период);
	СтруктураСотрудник.Вставить("Организация", Объект.Организация);
	
	ПолучитьДанныеСотрудника(СтруктураСотрудник);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, СтруктураСотрудник);
		
	ТекущиеДанные.ПрежнееПодразделение = СтруктураСотрудник.СтруктурнаяЕдиница;
	ТекущиеДанные.ПрежняяДолжность = СтруктураСотрудник.Должность;
	ТекущиеДанные.ПрежнееКоличествоЗанимаемыхСтавок = СтруктураСотрудник.ЗанимаемыхСтавок;
	ТекущиеДанные.ПрежнийГрафикРаботы = СтруктураСотрудник.ГрафикРаботы;
	
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.СтруктурнаяЕдиница) Тогда
		ТекущиеДанные.СтруктурнаяЕдиница = ОсновноеПодразделение;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события ПриИзменении Период табличной части Сотрудники.
//
Процедура СотрудникиПериодПриИзменении(Элемент)
	
	Если Объект.ВидОперации <> ПредопределенноеЗначение("Перечисление.ВидыОперацийКадровоеПеремещение.ПеремещениеИИзменениеСпособаОплаты") Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	
	СтруктураСотрудник = Новый Структура();
	СтруктураСотрудник.Вставить("Сотрудник", ТекущиеДанные.Сотрудник);
	СтруктураСотрудник.Вставить("Период", ТекущиеДанные.Период);
	СтруктураСотрудник.Вставить("Организация", Объект.Организация);
	
	ПолучитьДанныеСотрудника(СтруктураСотрудник);
	
	ТекущиеДанные.ПрежнееПодразделение = СтруктураСотрудник.СтруктурнаяЕдиница;
	ТекущиеДанные.ПрежняяДолжность = СтруктураСотрудник.Должность;
	ТекущиеДанные.ПрежнееКоличествоЗанимаемыхСтавок = СтруктураСотрудник.ЗанимаемыхСтавок;
	ТекущиеДанные.ПрежнийГрафикРаботы = СтруктураСотрудник.ГрафикРаботы;
	
	Если НЕ ЗначениеЗаполнено(ТекущиеДанные.СтруктурнаяЕдиница) И НЕ ЗначениеЗаполнено(ТекущиеДанные.Должность) И НЕ ЗначениеЗаполнено(ТекущиеДанные.ГрафикРаботы) Тогда	
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, СтруктураСотрудник);	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события ПриНачалеРедактирования табличной части НачисленияУдержания.
//
Процедура НачисленияУдержанияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		УправлениеНебольшойФирмойКлиент.ДобавитьКлючСвязиВСтрокуПодчиненнойТабличнойЧасти(ЭтаФорма, Элемент.Имя);
		СтрокаТабличнойЧасти = Элементы.НачисленияУдержания.ТекущиеДанные;
		СтрокаТабличнойЧасти.Валюта = ВалютаПоУмолчанию;
		СтрокаТабличнойЧасти.Актуальность = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события ПередНачаломДобавления табличной части НачисленияУдержания.
//
Процедура НачисленияУдержанияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = УправлениеНебольшойФирмойКлиент.ПередНачаломДобавленияВПодчиненнуюТабличнуюЧасть(ЭтаФорма, Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события ПриИзменении ВидНачисленияУдержания табличной части НачисленияУдержания.
//
Процедура НачисленияУдержанияВидНачисленияУдержанияПриИзменении(Элемент)
	
	УправлениеНебольшойФирмойКлиент.ПроставитьСчетЗатратПоУмолчанию(ЭтаФорма);
	
КонецПроцедуры // НачисленияУдержанияВидНачисленияУдержанияПриИзменении()

&НаКлиенте
// Процедура - обработчик события ПриНачалеРедактирования табличной части НалогиНаДоходы.
//
Процедура НалогиНаДоходыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		УправлениеНебольшойФирмойКлиент.ДобавитьКлючСвязиВСтрокуПодчиненнойТабличнойЧасти(ЭтаФорма, Элемент.Имя);
		СтрокаТабличнойЧасти = Элементы.НалогиНаДоходы.ТекущиеДанные;
		СтрокаТабличнойЧасти.Валюта = ВалютаПоУмолчанию;
		СтрокаТабличнойЧасти.Актуальность = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события ПередНачаломДобавления табличной части НалогиНаДоходы.
//
Процедура НалогиНаДоходыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = УправлениеНебольшойФирмойКлиент.ПередНачаломДобавленияВПодчиненнуюТабличнуюЧасть(ЭтаФорма, Элемент.Имя);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Объект);
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
		
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

