﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ТекСтрокаПолучатели = ПараметрыВыполненияКоманды.Источник.Элементы.Получатели.ТекущиеДанные;
	
	Если ТекСтрокаПолучатели = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭлектроннаяПочтаУНФКлиентСервер.КонтактУжеСоздан(
		ТекСтрокаПолучатели.Контакт,
		НСтр("ru = 'Контакт уже привязан.'"),
		ПараметрыВыполненияКоманды.Источник) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Контакт", ТекСтрокаПолучатели.Контакт);
	ПараметрыОповещения.Вставить("КакСвязаться", ТекСтрокаПолучатели.КакСвязаться);
	ПараметрыОповещения.Вставить("ЭлементПолучатели", ПараметрыВыполненияКоманды.Источник.Элементы.Получатели);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
	"ОбработатьВыборКонтрагента",
	ЭтотОбъект,
	ПараметрыОповещения);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	
	ОткрытьФорму("Справочник.Контрагенты.ФормаВыбора",
	ПараметрыФормы,,,,,
	ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьВыборКонтрагента(Контрагент, ПараметрыОповещения) Экспорт
	
	Если Не ЗначениеЗаполнено(Контрагент) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = ПараметрыФормыПривязкиКонтакта(
	Контрагент,
	ПараметрыОповещения.Контакт,
	ПараметрыОповещения.КакСвязаться);
	
	ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта",
	ПараметрыФормы,
	ПараметрыОповещения.ЭлементПолучатели);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыФормыПривязкиКонтакта(Контрагент, Контакт, КакСвязаться)
	
	Результат = Новый Структура;
	Результат.Вставить("РежимВыбора", Истина);
	Результат.Вставить("Ключ", Контрагент);
	Результат.Вставить("КонтактКакСвязаться", Новый Структура);
	Результат.КонтактКакСвязаться.Вставить("ВидКонтакта", "КонтактноеЛицо");
	Результат.КонтактКакСвязаться.Вставить("Контакт", Контакт);
	Результат.КонтактКакСвязаться.Вставить("КакСвязаться", КакСвязаться);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
