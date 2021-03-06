﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("Ссылка") Тогда
		ОбъектОбсуждения = Параметры.Ссылка;
	Иначе
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Обсуждение = ОбсужденияВызовСервера.ОбсужденияПоОбъекту(ОбъектОбсуждения);
	
КонецПроцедуры

#Область Обсуждения

&НаКлиенте
Процедура СообщениеАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	ОбсужденияКлиент.СообщениеАвтоПодбор(ЭтаФорма, ОбъектОбсуждения, Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СообщениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбсужденияКлиент.СообщениеОбработкаВыбора(ЭтаФорма, ОбъектОбсуждения, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСообщение(Команда)
	
	ОбсужденияКлиент.ДобавитьСообщение(СообщениеПользователя, ОбъектОбсуждения, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбсуждениеПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СообщениеПользователя = Элементы.Сообщение.ТекстРедактирования;
	ОбсужденияКлиент.ОбработатьНажатие(ЭтаФорма, Элемент, ДанныеСобытия, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбсуждениеДобавитьСимволСобака(Команда)
	
	Если Прав(Элементы.Сообщение.ТекстРедактирования, 1)=" " ИЛИ ПустаяСтрока(Элементы.Сообщение.ТекстРедактирования) Тогда
		Элементы.Сообщение.ВыделенныйТекст = "@";
	Иначе
		Элементы.Сообщение.ВыделенныйТекст = " @";
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОбсуждения() Экспорт
	
	Обсуждение = ОбсужденияВызовСервера.ОбсужденияПоОбъекту(ОбъектОбсуждения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если НЕ Источник=ОбъектОбсуждения Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяСобытия="Обсуждение_ДобавлениеКомментария" Тогда
		ОбновитьОбсуждения();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
