﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СчетУчета = Параметры.СчетУчета;
	СчетАмортизации = Параметры.СчетАмортизации;
	
	Если ОтказИзменитьСчетУчета(Ссылка) Тогда
		Элементы.ГруппаСчетовУчета.Подсказка = НСтр("ru = 'В базе есть движения по этому внеоборотному активу! Изменение счетов учета запрещено!'");
		Элементы.ГруппаСчетовУчета.Доступность = Ложь;
		Элементы.ПоУмолчанию.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СчетУчетаПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СчетУчета) Тогда
		СчетУчета = ПредопределенноеЗначение("ПланСчетов.Управленческий.ВнеоборотныеАктивы");
	КонецЕсли;
	ОповеститьОбИзмененииСчетовРасчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетАмортизацииПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(СчетАмортизации) Тогда
		СчетАмортизации = ПредопределенноеЗначение("ПланСчетов.Управленческий.АмортизацияВнеоборотныхАктивов");
	КонецЕсли;
	ОповеститьОбИзмененииСчетовРасчетов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоУмолчанию(Команда)
	
	СчетУчета = ПредопределенноеЗначение("ПланСчетов.Управленческий.ВнеоборотныеАктивы");
	СчетАмортизации = ПредопределенноеЗначение("ПланСчетов.Управленческий.АмортизацияВнеоборотныхАктивов");
	
	ОповеститьОбИзмененииСчетовРасчетов();
	
КонецПроцедуры // ПоУмолчанию()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция проверяет возможность изменения счета учета.
//
&НаСервере
Функция ОтказИзменитьСчетУчета(ТекстСообщения)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВнеоборотныеАктивы.Период,
	|	ВнеоборотныеАктивы.Регистратор,
	|	ВнеоборотныеАктивы.НомерСтроки,
	|	ВнеоборотныеАктивы.Активность,
	|	ВнеоборотныеАктивы.ВидДвижения,
	|	ВнеоборотныеАктивы.Организация,
	|	ВнеоборотныеАктивы.ВнеоборотныйАктив,
	|	ВнеоборотныеАктивы.Стоимость,
	|	ВнеоборотныеАктивы.Амортизация,
	|	ВнеоборотныеАктивы.СодержаниеПроводки
	|ИЗ
	|	РегистрНакопления.ВнеоборотныеАктивы КАК ВнеоборотныеАктивы
	|ГДЕ
	|	ВнеоборотныеАктивы.ВнеоборотныйАктив = &ВнеоборотныйАктив");
	
	Запрос.УстановитьПараметр("ВнеоборотныйАктив", ?(ЗначениеЗаполнено(Ссылка), Ссылка, Неопределено));
	
	Результат = Запрос.Выполнить();
	
	Возврат НЕ Результат.Пустой();
	
КонецФункции // ОтказИзменитьСчетУчета()

&НаКлиенте
Процедура ОповеститьОбИзмененииСчетовРасчетов()
	
	СтруктураПараметры = Новый Структура("СчетУчета, СчетАмортизации", СчетУчета, СчетАмортизации);
	Оповестить("ИзменилисьСчетаВнеоборотныеАктивы", СтруктураПараметры);
	
КонецПроцедуры

#КонецОбласти
