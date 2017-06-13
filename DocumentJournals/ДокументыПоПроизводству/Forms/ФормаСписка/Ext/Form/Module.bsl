﻿
#Область ОбработчикиСобытий

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере формы
// 
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка способа выбора структурной единицы в зависимости от ФО.
	Если НЕ Константы.ФункциональнаяОпцияУчетПоНесколькимПодразделениям.Получить()
		И НЕ Константы.ФункциональнаяОпцияУчетПоНесколькимСкладам.Получить() Тогда
		Элементы.ОтборСклад.РежимВыбораИзСписка = Истина;
		Элементы.ОтборСклад.СписокВыбора.Добавить(Справочники.СтруктурныеЕдиницы.ОсновнойСклад);
		Элементы.ОтборСклад.СписокВыбора.Добавить(Справочники.СтруктурныеЕдиницы.ОсновноеПодразделение);
	КонецЕсли;
	
	//УНФ.ОтборыСписка
	ЗаполнитьВидыОпераций();
	Если Параметры.Свойство("ЭтоНачальнаяСтраница") Тогда
		РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список);
		ЭтоНачальнаяСтраница = Ложь;
	Иначе
		ЭтоНачальнаяСтраница = Истина;
		РаботаСОтборами.СвернутьРазвернутьОтборыНаСервере(ЭтотОбъект, Ложь);
		ПредставлениеПериода = РаботаСОтборамиКлиентСервер.ОбновитьПредставлениеПериода(Неопределено);
	КонецЕсли;
	//Конец УНФ.ОтборыСписка
	
	// Установим формат для текущей даты: ДФ=Ч:мм
	УправлениеНебольшойФирмойСервер.УстановитьОформлениеКолонкиДата(Список);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВидыОпераций()
	
	//Для "заказов на сборку" и "сборки запасов" имена значений перечислений "сборка", "разборка" совпадают,
	//поэтому используются перечисления ВидыОперацийСборкаЗапасов
	Для каждого ВидОперации Из Метаданные.Перечисления.ВидыОперацийСборкаЗапасов.ЗначенияПеречисления Цикл
		Элементы.ОтборОперация.СписокВыбора.Добавить(Перечисления.ВидыОперацийСборкаЗапасов[ВидОперации.Имя], ВидОперации.Синоним);
	КонецЦикла;
	Для каждого ВидОперации Из Метаданные.Перечисления.ВидыОперацийПеремещениеЗапасов.ЗначенияПеречисления Цикл
		Элементы.ОтборОперация.СписокВыбора.Добавить(Перечисления.ВидыОперацийПеремещениеЗапасов[ВидОперации.Имя], ВидОперации.Синоним);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы Тогда
		//УНФ.ОтборыСписка
		СохранитьНастройкиОтборов();
		//Конец УНФ.ОтборыСписка
	КонецЕсли; 

КонецПроцедуры

// Процедура - обработчик события формы "ПриЗагрузкеДанныхИзНастроекНаСервере".
//
&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОтборТипЗаказНаПроизводство	= Настройки.Получить("ОтборТипЗаказНаПроизводство");
	ОтборТипРаспределениеЗатрат	= Настройки.Получить("ОтборТипРаспределениеЗатрат");
	ОтборТипПеремещение			= Настройки.Получить("ОтборТипПеремещение");
	ОтборТипСборка				= Настройки.Получить("ОтборТипСборка");
	
	УстановитьОтборПоТипуДокумента();
	
КонецПроцедуры // ПриЗагрузкеДанныхИзНастроекНаСервере()

&НаСервере
Процедура УстановитьОтборПоТипуДокумента()
	
	МассивОтбора = Новый Массив;
	Если ОтборТипЗаказНаПроизводство Тогда
		МассивОтбора.Добавить(Тип("ДокументСсылка.ЗаказНаПроизводство"));
	КонецЕсли;
	Если ОтборТипПеремещение Тогда
		МассивОтбора.Добавить(Тип("ДокументСсылка.ПеремещениеЗапасов"));
	КонецЕсли;
	Если ОтборТипРаспределениеЗатрат Тогда
		МассивОтбора.Добавить(Тип("ДокументСсылка.РаспределениеЗатрат"));
	КонецЕсли;
	Если ОтборТипСборка Тогда
		МассивОтбора.Добавить(Тип("ДокументСсылка.СборкаЗапасов"));
	КонецЕсли;
	
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Тип", МассивОтбора, ЗначениеЗаполнено(МассивОтбора));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьПоШаблону(Команда)
	
	ИсключитьТипы = Новый Массив;
	ИсключитьТипы.Добавить(Тип("ДокументСсылка.РаспределениеЗатрат"));
	
	ЗаполнениеОбъектовУНФКлиент.ПоказатьВыборШаблонаДляСозданияДокументаИзСписка(Список, Элементы.Список.ТекущаяСтрока, ИсключитьТипы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТипДокументаПриИзменении(Элемент)
	
	УстановитьОтборПоТипуДокумента();
	
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
Процедура ОтборЗаказНаПроизводствоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеДокумента = СтрЗаменить(ВыбранноеЗначение, "Заказ на производство", "Заказ");
	УстановитьМеткуИОтборСписка("ЗаказНаПроизводство", Элемент.Родитель.Имя, ВыбранноеЗначение, ПредставлениеДокумента);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборЗаказПокупателяОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеДокумента = СтрЗаменить(ВыбранноеЗначение, "Заказ покупателя", "Заказ");
	УстановитьМеткуИОтборСписка("ЗаказПокупателя", Элемент.Родитель.Имя, ВыбранноеЗначение, ПредставлениеДокумента);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОперацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	//Для "заказов на сборку" и "сборки запасов" имена значений перечислений "сборка", "разборка" совпадают,
	//отбор устанавливается на оба варианта сборки или разборки	
	Если ВыбранноеЗначение = ПредопределенноеЗначение("Перечисление.ВидыОперацийСборкаЗапасов.Сборка") Тогда
		МассивСборка = Новый Массив;
		МассивСборка.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийСборкаЗапасов.Сборка"));
		МассивСборка.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийЗаказНаПроизводство.Сборка"));
		УстановитьМеткуИОтборСписка("ВидОперации", Элемент.Родитель.Имя, МассивСборка, "Сборка");
	ИначеЕсли ВыбранноеЗначение = ПредопределенноеЗначение("Перечисление.ВидыОперацийСборкаЗапасов.Разборка") Тогда	
		МассивРазборка = Новый Массив;
		МассивРазборка.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийСборкаЗапасов.Разборка"));
		МассивРазборка.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийЗаказНаПроизводство.Разборка"));
		УстановитьМеткуИОтборСписка("ВидОперации", Элемент.Родитель.Имя, МассивРазборка, "Разборка");
	Иначе
		УстановитьМеткуИОтборСписка("ВидОперации", Элемент.Родитель.Имя, ВыбранноеЗначение);
	КонецЕсли; 
	
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

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование Тогда
		возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Параметр) Тогда
		возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	СтруктураПараметров = Новый Структура();
	РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ДанныеМеток, СтруктураПараметров, "СтруктурнаяЕдиница");
	РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ДанныеМеток, СтруктураПараметров, "ВидОперации");
	РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ДанныеМеток, СтруктураПараметров, "Организация");
		
	ИмяФормыСтрока = РаботаСФормойДокументаКлиент.ПолучитьИмяДокументаПоТипу(Параметр);
	ОткрытьФорму("Документ."+ИмяФормыСтрока+".ФормаОбъекта", Новый Структура("ЗначенияЗаполнения",СтруктураПараметров));

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
	
	Если НЕ ЭтоНачальнаяСтраница Тогда
		РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
		
КонецПроцедуры

#КонецОбласти
