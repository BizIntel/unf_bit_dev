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
		НСтр("ru = 'Контактное лицо уже создано.'"),
		ПараметрыВыполненияКоманды.Источник) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = ПараметрыФормыСозданияКонтакта(
	ТекСтрокаПолучатели.Контакт,
	ТекСтрокаПолучатели.КакСвязаться);
	
	ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта",
	ПараметрыФормы,
	ПараметрыВыполненияКоманды.Источник.Элементы.Получатели);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПараметрыФормыСозданияКонтакта(Контакт, КакСвязаться)
	
	Результат = Новый Структура;
	Результат.Вставить("РежимВыбора", Истина);
	Результат.Вставить("ЗначенияЗаполнения", Новый Структура);
	Результат.ЗначенияЗаполнения.Вставить("Покупатель", Истина);
	Результат.ЗначенияЗаполнения.Вставить("ВидКонтрагента", Перечисления.ВидыКонтрагентов.ФизическоеЛицо);
	Результат.Вставить("КонтактКакСвязаться", Новый Структура);
	Результат.КонтактКакСвязаться.Вставить("ВидКонтакта", "КонтактноеЛицо");
	Результат.КонтактКакСвязаться.Вставить("Контакт", Контакт);
	Результат.КонтактКакСвязаться.Вставить("КакСвязаться", КакСвязаться);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
