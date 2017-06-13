﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураРеквизитов = Параметры.СтруктураРеквизитов;
	Если СтруктураРеквизитов <> Неопределено Тогда
		
		Элементы.РольУчастника.СписокВыбора.ЗагрузитьЗначения(СтруктураРеквизитов.СписокРолейУчастников.ВыгрузитьЗначения());
		ПустойЭлементСпкиска = Элементы.РольУчастника.СписокВыбора.НайтиПоЗначению(Перечисления.РолиУчастниковСделкиДокументаПоТребованиюФНС.ПустаяСсылка());
		Если ПустойЭлементСпкиска <> Неопределено Тогда
			ПустойЭлементСпкиска.Представление = "-------------------------------------------------------------------";	
		КонецЕсли;
		
		Контрагент 			= СтруктураРеквизитов.Контрагент; 
		ЮрЛицоНаименование 	= СтруктураРеквизитов.ЮрЛицоНаименование; 
		ЮрЛицоИНН 			= СтруктураРеквизитов.ЮрЛицоИНН; 
		ЮрЛицоКПП 			= СтруктураРеквизитов.ЮрЛицоКПП; 
		ФизЛицоФамилия 		= СтруктураРеквизитов.ФизЛицоФамилия; 
		ФизЛицоИмя 			= СтруктураРеквизитов.ФизЛицоИмя; 
		ФизЛицоОтчество 	= СтруктураРеквизитов.ФизЛицоОтчество; 
		ФизЛицоИНН 			= СтруктураРеквизитов.ФизЛицоИНН; 
		ЯвляетсяЮрЛицом 	= СтруктураРеквизитов.ЯвляетсяЮрЛицом; 
		ВидДокумента 		= СтруктураРеквизитов.ВидДокумента; 
		РольУчастника 		= СтруктураРеквизитов.РольУчастника; 
		
	КонецЕсли;
	
	Если ЭлектронныйДокументооборотСКонтролирующимиОрганами.СправочникКонтрагентовДоступен() Тогда
		Элементы.Контрагент.Видимость = Истина;
		Элементы.ГруппаПодсказкаКонтрагент.Видимость = Истина;
	Иначе
		Элементы.Контрагент.Видимость = Ложь;
		Элементы.ГруппаПодсказкаКонтрагент.Видимость = Ложь;
	КонецЕсли;
	
	УправлениеЭУ(ЭтотОбъект);
	
	Если ЯвляетсяЮрЛицом Тогда
		ЭтаФорма.ТекущийЭлемент = Элементы.ЮрЛицоНаименование;
	Иначе
		ЭтаФорма.ТекущийЭлемент = Элементы.ФизЛицоФамилия;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеЭУ(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЯвляетсяЮЛПриИзменении(Элемент)
	
	УправлениеЭУ(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ЗаполнитьДаннымиКонтрагента();
	
КонецПроцедуры

&НаКлиенте
Процедура РольУчастникаПриИзменении(Элемент)
	УправлениеЭУ(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если ПроверкаЗаполнения() = Ложь Тогда
		Возврат;
	КонецЕсли;

	Если ЯвляетсяЮрЛицом Тогда
		ФизЛицоИНН			= "";
		ФизЛицоФамилия  	= "";	
		ФизЛицоИмя      	= "";	
		ФизЛицоОтчество 	= "";	
	Иначе
	    ЮрЛицоНаименование 	= ""; 
		ЮрЛицоИНН 			= ""; 
		ЮрЛицоКПП 			= ""; 
	КонецЕсли;

	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("ЮрЛицоНаименование", 	ЮрЛицоНаименование); 
	СтруктураРеквизитов.Вставить("ЮрЛицоИНН", 			ЮрЛицоИНН); 
	СтруктураРеквизитов.Вставить("ЮрЛицоКПП", 			ЮрЛицоКПП); 
	СтруктураРеквизитов.Вставить("ФизЛицоФамилия", 		ФизЛицоФамилия); 
	СтруктураРеквизитов.Вставить("ФизЛицоИмя", 			ФизЛицоИмя); 
	СтруктураРеквизитов.Вставить("ФизЛицоОтчество", 	ФизЛицоОтчество); 
	СтруктураРеквизитов.Вставить("ФизЛицоИНН", 			ФизЛицоИНН); 
	СтруктураРеквизитов.Вставить("ЯвляетсяЮрЛицом", 	ЯвляетсяЮрЛицом); 
	СтруктураРеквизитов.Вставить("Контрагент", 			Контрагент); 
	СтруктураРеквизитов.Вставить("РольУчастника", 		РольУчастника); 
	
	Закрыть(СтруктураРеквизитов);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	ВозвращаемоеЗначение = Неопределено;
	Закрыть(ВозвращаемоеЗначение);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПроверкаЗаполнения()
	
	ЕстьОшибки = Ложь;
	
	Если НЕ ЗначениеЗаполнено(РольУчастника) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указана роль участника сделки.'"));
		ЕстьОшибки = Истина;
	КонецЕсли;

	Если ЯвляетсяЮрЛицом Тогда
		
		Если НЕ ЗначениеЗаполнено(ЮрЛицоНаименование) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указано наименование организации.'"));
			ЕстьОшибки = Истина;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ЮрЛицоИНН) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указан ИНН организации.'"));
			ЕстьОшибки = Истина;
		ИначеЕсли СтрДлина(СокрЛП(ЮрЛицоИНН)) <> 10 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Некорректная длина ИНН организации.'"));
			ЕстьОшибки = Истина;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ЮрЛицоКПП) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указан КПП организации.'"));
			ЕстьОшибки = Истина;
		ИначеЕсли СтрДлина(СокрЛП(ЮрЛицоКПП)) <> 9 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Некорректная длина КПП организации.'"));
			ЕстьОшибки = Истина;
		КонецЕсли;
		
	Иначе
		
		Если НЕ ЗначениеЗаполнено(ФизЛицоФамилия) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указана фамилия физического лица.'"));
			ЕстьОшибки = Истина;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ФизЛицоИмя) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указано имя физического лица.'"));
			ЕстьОшибки = Истина;
		КонецЕсли;
		
		ИННОбязательно = ОбязательноЗаполнениеИННДляИП(ВидДокумента);
		Если ИННОбязательно И НЕ ЗначениеЗаполнено(ФизЛицоИНН) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указан ИНН физического лица.'"));
			ЕстьОшибки = Истина;
		ИначеЕсли ИННОбязательно И СтрДлина(СокрЛП(ФизЛицоИНН)) <> 12 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Некорректная длина ИНН физического лица.'"));
			ЕстьОшибки = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЕстьОшибки Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли; 

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОбязательноЗаполнениеИННДляИП(ВидДокумента)
	
	// ПРИКАЗ от 29 июня 2012 г. N ММВ-7-6/465@
	// Типовой элемент <ИННФЛТип>. Обязателен для <КодДок>=2181 | 2330 | 2745 | 2766.
	// Может заполняться для <КодДок>=0924 | 1665 | 2234 | 2772.

	Если ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.АктПриемкиСдачиРабот")
		ИЛИ ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.СпецификацияЦены")
		ИЛИ ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.Договор")
		ИЛИ ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.ДополнениеКДоговору") Тогда 
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭУ(Форма)
	
	Элементы 		= Форма.Элементы;
	ВидДокумента 	= Форма.ВидДокумента;
	
	Если Форма.ЯвляетсяЮрЛицом Тогда
		Элементы.ГруппаЮрФиз.ТекущаяСтраница = Элементы.ГруппаЮрЛицо;
		КонтрагентПодсказка = "При выборе контрагента Наименование, ИНН и КПП заполнятся автоматически";
	Иначе
		
		Элементы.ГруппаЮрФиз.ТекущаяСтраница = Элементы.ГруппаФизЛицо;
		КонтрагентПодсказка = "При выборе контрагента ФИО и ИНН заполнятся автоматически";
		
		Если ОбязательноЗаполнениеИННДляИП(ВидДокумента) Тогда 
			Элементы.ФизЛицоИНН.АвтоОтметкаНезаполненного = Истина;
		Иначе
			Элементы.ФизЛицоИНН.АвтоОтметкаНезаполненного = Ложь;
		КонецЕсли;

		
	КонецЕсли;
	
	Элементы.КонтрагентПодсказка.Заголовок = КонтрагентПодсказка;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДаннымиКонтрагента()
	
	ЗаполнитьДаннымиКонтрагентаНаСервере();
	УправлениеЭУ(ЭтотОбъект);	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДаннымиКонтрагентаНаСервере()
	Если ЗначениеЗаполнено(Контрагент) Тогда
		
		//наличие всех реквизитов предварительно проверяется в функции ЭлектронныйДокументооборотСКонтролирующимиОрганами.СправочникКонтрагентовДоступен()
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Контрагенты.НаименованиеПолное,
		|	Контрагенты.ЮридическоеФизическоеЛицо,
		|	Контрагенты.ИНН,
		|	Контрагенты.КПП
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.Ссылка = &КонтрагентСсылка";
		
		Запрос.УстановитьПараметр("КонтрагентСсылка", Контрагент);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			ЯвляетсяЮрЛицом = (Выборка.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо);
			
			Если ЯвляетсяЮрЛицом Тогда
				
				ЮрЛицоНаименование = Выборка.НаименованиеПолное; 
				ЮрЛицоИНН = Выборка.ИНН; 
				ЮрЛицоКПП = Выборка.КПП; 
				
			Иначе
				
				ФизЛицоИНН  = Выборка.ИНН;
				
				ФИО = РегламентированнаяОтчетность.РазложитьФИО(Выборка.НаименованиеПолное);
				ФизЛицоФамилия  = ФИО.Фамилия;	
				ФизЛицоИмя      = ФИО.Имя;	
				ФизЛицоОтчество = ФИО.Отчество;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти