﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Возврат", ТолькоВозвраты) Тогда
		
		СписокЗначений = Новый СписокЗначений;
		СписокЗначений.Добавить(Перечисления.ВидыОперацийПриходнаяНакладная.ВозвратОтКомиссионера);
		СписокЗначений.Добавить(Перечисления.ВидыОперацийПриходнаяНакладная.ВозвратОтПереработчика);
		СписокЗначений.Добавить(Перечисления.ВидыОперацийПриходнаяНакладная.ВозвратОтПокупателя);
		СписокЗначений.Добавить(Перечисления.ВидыОперацийПриходнаяНакладная.ВозвратСОтветхранения);
		
		РаботаСФормойДокумента.УдалитьНедоступныеВидыОперацийДокументов(СписокЗначений);
		
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список,"ВидОперации",СписокЗначений,Истина,ВидСравненияКомпоновкиДанных.ВСписке);
		
		Элементы.ОтборОперация.РежимВыбораИзСписка = Истина;
		Элементы.ОтборОперация.СписокВыбора.ЗагрузитьЗначения(СписокЗначений.ВыгрузитьЗначения());
		
		Элементы.ОтборКонтрагент.ПодсказкаВвода = "Покупатель, ИНН, телефон";
		Элементы.Контрагент.Заголовок = "Покупатель / Поставщик";
		
		ЭтотОбъект.АвтоЗаголовок = Ложь;
		ЭтотОбъект.Заголовок = "Возвраты от контрагентов";
		
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		Элементы.ФОГруппаСписок.ОтображатьЗаголовок = Истина;
		Элементы.ФОГруппаСписок.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
		Элементы.ФОГруппаСписок.Заголовок = "Приходные накладные (на возврат)";
		Элементы.СтраницаЗаказыПоставщикам.Видимость = Ложь;
		
	Иначе
		
		СостоянияЗаказов.УстановитьУсловноеОформлениеОтмененногоЗаказа(
			СписокЗаказыПоставщикам.КомпоновщикНастроек.Настройки.УсловноеОформление
		);
		
		УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
		
		ЗаполнитьВидыОпераций();
		
		// Установим формат для текущей даты: ДФ=Ч:мм
		УправлениеНебольшойФирмойСервер.УстановитьОформлениеКолонкиДата(СписокЗаказыПоставщикам);
		
	КонецЕсли;
	
	УправлениеНебольшойФирмойСервер.УстановитьОформлениеКолонкиДата(Список);
	
	//УНФ.ОтборыСписка
	РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список);
	//Конец УНФ.ОтборыСписка
	
	// ЭДО
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСписка();
	ПараметрыПриСозданииНаСервере.Форма = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд = Элементы.ГруппаКомандыЭДО;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСписка(Отказ, СтандартнаяОбработка, ПараметрыПриСозданииНаСервере);
	// Конец ЭДО
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	УправлениеНебольшойФирмойСервер.УстановитьОтображаниеПодменюПечати(Элементы.ПодменюПечать);
	
	// УНФ.ПанельКонтактнойИнформации
	КонтактнаяИнформацияПанельУНФ.ПриСозданииНаСервере(ЭтотОбъект, "КонтактнаяИнформация");
	// Конец УНФ.ПанельКонтактнойИнформации
	
	// МобильноеПриложение
	Если МобильноеПриложениеВызовСервера.НужноОграничитьФункциональность() Тогда
		Элементы.ФормаСоздатьПоШаблону.Видимость = Ложь;
		Элементы.ФормаОбщаяКомандаНапомнить.Видимость = Ложь;
		Элементы.ГруппаГлобальныеКомандыНакладные.Видимость = Ложь;
		Элементы.ГруппаКомандыЭДО.Видимость = Ложь;
		Элементы.ФормаОбработкаНастройкиПриложенияБольшеВозможностей.Видимость = Ложь;
		Элементы.ПраваяПанель.Видимость = Ложь;
		Элементы.СтраницаЗаказыПоставщикам.Видимость = Ложь;
		Элементы.ВидОперации.Видимость = Ложь;
		Элементы.СтраницаЗаказыПоставщикам.Видимость = Ложь;
	КонецЕсли;
	// Конец МобильноеПриложение
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// ЭДО
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭДО
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы Тогда
		//УНФ.ОтборыСписка
		СохранитьНастройкиОтборов();
		//Конец УНФ.ОтборыСписка
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_СостоянияЗаказовПоставщикам" Тогда
		УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	КонецЕсли;
	
	// ЭДО
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = ЭтотОбъект;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "Список";
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец ЭДО
	
	// УНФ.ПанельКонтактнойИнформации
	Если КонтактнаяИнформацияПанельУНФКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьПанельКонтактнойИнформацииСервер();
	КонецЕсли;
	// Конец УНФ.ПанельКонтактнойИнформации
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если ТипЗнч(Элемент.ТекущаяСтрока) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		
		КонтрагентАктивнойСтроки = ?(Элемент.ТекущиеДанные = Неопределено, Неопределено, Элемент.ТекущиеДанные.Контрагент);
		Если КонтрагентАктивнойСтроки <> ТекущийКонтрагент Тогда
		
			ТекущийКонтрагент = КонтрагентАктивнойСтроки;
			ПодключитьОбработчикОжидания("ОбработатьАктивизациюСтрокиСписка", 0.2, Истина);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "СозданиеФормы" + РаботаСФормойДокументаКлиентСервер.ПолучитьИмяФормыСтрокой(ЭтотОбъект.ИмяФормы));
	
	Если Не ТолькоВозвраты Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидОперацииВозврат", ТолькоВозвраты);
	ОткрытьФорму("Документ.ПриходнаяНакладная.ФормаОбъекта", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ОткрытиеФормы" + РаботаСФормойДокументаКлиентСервер.ПолучитьИмяФормыСтрокой(ЭтотОбъект.ИмяФормы));
	
	Если Элемент.ТекущаяСтрока = Неопределено
		ИЛИ Не ТолькоВозвраты Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидОперацииВозврат", ТолькоВозвраты);
	ПараметрыФормы.Вставить("Ключ", Элемент.ТекущаяСтрока);
	ОткрытьФорму("Документ.ПриходнаяНакладная.ФормаОбъекта", ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Контрагент", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;

КонецПроцедуры

&НаКлиенте
Процедура ОтборСкладОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("СтруктурнаяЕдиница", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОперацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("ВидОперации", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтветственныйОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;

	УстановитьМеткуИОтборСписка("Ответственный", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Организация", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьПриходнуюНакладную(Команда)
	
	Если Элементы.СписокЗаказыПоставщикам.ТекущиеДанные = Неопределено Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Команда не может быть выполнена для указанного объекта!'");
		ПоказатьПредупреждение(Неопределено,ТекстПредупреждения);
		Возврат;
		
	КонецЕсли;
	
	МассивЗаказов = Элементы.СписокЗаказыПоставщикам.ВыделенныеСтроки;
	
	Если МассивЗаказов.Количество() = 1 Тогда
		
		ПараметрыОткрытия = Новый Структура("Основание", МассивЗаказов[0]);
		ОткрытьФорму("Документ.ПриходнаяНакладная.ФормаОбъекта", ПараметрыОткрытия);
		
	Иначе
		
		СтруктураДанных = ПроверитьКлючевыеРеквизитыЗаказов(МассивЗаказов);
		Если СтруктураДанных.СформироватьНесколькоЗаказов Тогда
			
			ТекстСообщения = НСтр("ru = 'Заказы отличаются данными (%ПредставлениеДанных%) шапки документов! Сформировать несколько приходных накладных?'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПредставлениеДанных%", СтруктураДанных.ПредставлениеДанных);
			Ответ = Неопределено;

			ПоказатьВопрос(Новый ОписаниеОповещения("СоздатьПриходнуюНакладнуюЗавершение", ЭтотОбъект, Новый Структура("МассивЗаказов", МассивЗаказов)), ТекстСообщения, РежимДиалогаВопрос.ДаНет, 0);
			
		Иначе
			
			СтруктураЗаполнения = Новый Структура();
			СтруктураЗаполнения.Вставить("МассивЗаказовПоставщикам", МассивЗаказов);
			ОткрытьФорму("Документ.ПриходнаяНакладная.ФормаОбъекта", Новый Структура("Основание", СтруктураЗаполнения));
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПриходнуюНакладнуюЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    МассивЗаказов = ДополнительныеПараметры.МассивЗаказов;
    
    
    Ответ = Результат;
    Если Ответ = КодВозвратаДиалога.Да Тогда
        
        МассивДокументовПоступления = СформироватьДокументыПоступленияИЗаписать(МассивЗаказов);
        Текст = НСтр("ru='Создание:'");
        Для каждого СтрокаДокументПоступления Из МассивДокументовПоступления Цикл
            
            ПоказатьОповещениеПользователя(Текст, ПолучитьНавигационнуюСсылку(СтрокаДокументПоступления), СтрокаДокументПоступления, БиблиотекаКартинок.Информация32);
            
        КонецЦикла;
        
    КонецЕсли;

КонецПроцедуры // СоздатьПриходнуюНакладную()

&НаКлиенте
Процедура СоздатьПоШаблону(Команда)
	
	ЗаполнениеОбъектовУНФКлиент.ПоказатьВыборШаблонаДляСозданияДокументаИзСписка(Список, Элементы.Список.ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьВидыОпераций()
	
	СписокОпераций = Новый СписокЗначений;
	Для каждого ВидОперации Из Метаданные.Перечисления.ВидыОперацийПриходнаяНакладная.ЗначенияПеречисления Цикл
		СписокОпераций.Добавить(Перечисления.ВидыОперацийПриходнаяНакладная[ВидОперации.Имя]);
	КонецЦикла;
	
	РаботаСФормойДокумента.УдалитьНедоступныеВидыОперацийДокументов(СписокОпераций);
	Элементы.ОтборОперация.СписокВыбора.ЗагрузитьЗначения(СписокОпераций.ВыгрузитьЗначения());
	
КонецПроцедуры

// Обрабатывает событие активизации строки списка документов.
//
&НаКлиенте
Процедура ОбработатьАктивизациюСтрокиСписка()
	
	ОбновитьПанельКонтактнойИнформацииСервер();

КонецПроцедуры

// Функция проверяет отличие ключевых реквизитов.
//
&НаСервере
Функция ПроверитьКлючевыеРеквизитыЗаказов(МассивЗаказов)
	
	СтруктураДанных = Новый Структура();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПоставщикуШапка.Организация) КАК КоличествоОрганизация,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПоставщикуШапка.Контрагент) КАК КоличествоКонтрагент,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПоставщикуШапка.Договор) КАК КоличествоДоговор,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПоставщикуШапка.ВидЦенКонтрагента) КАК КоличествоВидЦен,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПоставщикуШапка.ВалютаДокумента) КАК КоличествоВалютаДокумента,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПоставщикуШапка.СуммаВключаетНДС) КАК КоличествоСуммаВключаетНДС,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПоставщикуШапка.НДСВключатьВСтоимость) КАК КоличествоНДСВключатьВСтоимость,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПоставщикуШапка.НалогообложениеНДС) КАК КоличествоНалогообложениеНДС
	|ИЗ
	|	Документ.ЗаказПоставщику КАК ЗаказПоставщикуШапка
	|ГДЕ
	|	ЗаказПоставщикуШапка.Ссылка В(&МассивЗаказов)
	|
	|ИМЕЮЩИЕ
	|	(КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПоставщикуШапка.Организация) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПоставщикуШапка.Контрагент) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПоставщикуШапка.Договор) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПоставщикуШапка.ВидЦенКонтрагента) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПоставщикуШапка.ВалютаДокумента) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПоставщикуШапка.СуммаВключаетНДС) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПоставщикуШапка.НДСВключатьВСтоимость) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПоставщикуШапка.НалогообложениеНДС) > 1)";
	
	Запрос.УстановитьПараметр("МассивЗаказов", МассивЗаказов);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		СтруктураДанных.Вставить("СформироватьНесколькоЗаказов", Ложь);
		СтруктураДанных.Вставить("ПредставлениеДанных", "");
	Иначе
		СтруктураДанных.Вставить("СформироватьНесколькоЗаказов", Истина);
		ПредставлениеДанных = "";
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.КоличествоОрганизация > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Организация", ", Организация");
			КонецЕсли;
			
			Если Выборка.КоличествоКонтрагент > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Контрагент", ", Контрагент");
			КонецЕсли;
			
			Если Выборка.КоличествоДоговор > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Договор", ", Договор");
			КонецЕсли;
			
			Если Выборка.КоличествоВидЦен > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Вид цен", ", Вид цен");
			КонецЕсли;
			
			Если Выборка.КоличествоВалютаДокумента > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Валюта", ", Валюта");
			КонецЕсли;
			
			Если Выборка.КоличествоСуммаВключаетНДС > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Сумма вкл. НДС", ", Сумма вкл. НДС");
			КонецЕсли;
			
			Если Выборка.КоличествоНДСВключатьВСтоимость > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "НДС вкл. в стоимость", ", НДС вкл. в стоимость");
			КонецЕсли;
			
			Если Выборка.КоличествоНалогообложениеНДС > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Налогообложение", ", Налогообложение");
			КонецЕсли;
			
		КонецЦикла;
		
		СтруктураДанных.Вставить("ПредставлениеДанных", ПредставлениеДанных);
		
	КонецЕсли;
	
	Возврат СтруктураДанных;
	
КонецФункции // ПроверитьКлючевыеРеквизитыЗаказов()

// Функция вызывает обработку заполнения документа по основанию.
//
&НаСервере
Функция СформироватьДокументыПоступленияИЗаписать(МассивЗаказов)
	
	МассивДокументовПоступления = Новый Массив();
	Для каждого СтрокаЗНП Из МассивЗаказов Цикл
		
		НовыйДокументПоступления = Документы.ПриходнаяНакладная.СоздатьДокумент();
		
		НовыйДокументПоступления.Дата = ТекущаяДата();
		НовыйДокументПоступления.Заполнить(СтрокаЗНП);
		
		НовыйДокументПоступления.Записать();
		МассивДокументовПоступления.Добавить(НовыйДокументПоступления.Ссылка);
		
	КонецЦикла;
	
	Элементы.Список.Обновить();
	
	Возврат МассивДокументовПоступления;
	
КонецФункции // СформироватьДокументыПоступленияИЗаписать()

&НаСервере
Процедура УстановитьУсловноеОформлениеПоЦветамСостоянийСервер()
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеПоЦветамСостояний(
		СписокЗаказыПоставщикам.КомпоновщикНастроек.Настройки.УсловноеОформление,
		Метаданные.Справочники.СостоянияЗаказовПоставщикам.ПолноеИмя()
	);
	
КонецПроцедуры

#КонецОбласти

#Область МеткиОтборов

&НаСервере
Процедура УстановитьМеткуИОтборСписка(ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения="")
	
	Если ПредставлениеЗначения="" Тогда
		ПредставлениеЗначения=Строка(ВыбранноеЗначение);
	КонецЕсли; 
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения);
	РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, Список, ИмяПоляОтбораСписка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_")+1);
	УдалитьМеткуОтбора(МеткаИД);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД)
	
	РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, Список, МеткаИД);

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборов()
	
	РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
		
КонецПроцедуры

#КонецОбласти

#Область ПанельКонтактнойИнформации

// УНФ.ПанельКонтактнойИнформации
&НаСервере
Процедура ОбновитьПанельКонтактнойИнформацииСервер()
	
	КонтактнаяИнформацияПанельУНФ.ОбновитьДанныеПанели(ЭтотОбъект, ТекущийКонтрагент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КонтактнаяИнформацияПанельУНФКлиент.ДанныеПанелиКонтактнойИнформацииВыбор(ЭтотОбъект, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииПриАктивизацииСтроки(Элемент)
	
	КонтактнаяИнформацияПанельУНФКлиент.ДанныеПанелиКонтактнойИнформацииПриАктивизацииСтроки(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииВыполнитьКоманду(Команда)
	
	КонтактнаяИнформацияПанельУНФКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры
// Конец УНФ.ПанельКонтактнойИнформации

#КонецОбласти

#Область ОбработчикиБиблиотек

// ЭДО
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеСлужебныйКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры
// Конец ЭДО

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти