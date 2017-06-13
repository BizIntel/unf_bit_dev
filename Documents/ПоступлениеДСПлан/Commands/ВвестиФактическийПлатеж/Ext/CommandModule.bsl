﻿
&НаСервере
Функция ПолучитьТипДенежныхСредств(ДокументСсылка)
	
	Возврат ДокументСсылка.ТипДенежныхСредств;
	
КонецФункции

&НаКлиенте
// Процедура обработки команды.
//
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Параметры = Новый Структура("Основание", ПараметрКоманды);
	
	ТипДенежныхСредств = ПолучитьТипДенежныхСредств(ПараметрКоманды);
	
	Если НЕ ЗначениеЗаполнено(ТипДенежныхСредств) Тогда
		ОткрытьФорму("ОбщаяФорма.ФормаТипыДенежныхСредств",,,,,, Новый ОписаниеОповещения("ОбработкаКомандыЗавершение", ЭтотОбъект, Новый Структура("Параметры", Параметры)));
		Возврат;
	КонецЕсли;
	
	ОбработкаКомандыФрагмент(Параметры, ТипДенежныхСредств);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКомандыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Параметры = ДополнительныеПараметры.Параметры;
	
	ТипДенежныхСредств = Результат;
	
	ОбработкаКомандыФрагмент(Параметры, ТипДенежныхСредств);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКомандыФрагмент(Знач Параметры, Знач ТипДенежныхСредств)
	
	Если ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Наличные") Тогда
		ОткрытьФорму("Документ.ПоступлениеВКассу.ФормаОбъекта", Параметры);
	ИначеЕсли ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Безналичные") Тогда 
		ОткрытьФорму("Документ.ПоступлениеНаСчет.ФормаОбъекта", Параметры);
	КонецЕсли;
	
КонецПроцедуры
 // ОбработкаКоманды()
