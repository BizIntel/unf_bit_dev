﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

///////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция СформироватьЗапросПоСтажуДляПроверкиЗаполнения()
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТаблицаЗаписиОСтаже", ЗаписиОСтаже);
	Запрос.УстановитьПараметр("ТаблицаСотрудники", Сотрудники);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТаблицаСотрудники.НомерСтроки,
	               |	ТаблицаСотрудники.Сотрудник,
				   |	ТаблицаСотрудники.Фамилия,
				   |	ТаблицаСотрудники.Имя,
	               |	ТаблицаСотрудники.АдресДляИнформирования,
	               |	ТаблицаСотрудники.СтраховойНомерПФР
	               |ПОМЕСТИТЬ ВТСотрудники
	               |ИЗ
	               |	&ТаблицаСотрудники КАК ТаблицаСотрудники";
				   
	Запрос.Выполнить();
	
	НачалоПериода = НачалоМесяца(ОтчетныйПериод);
	ОкончаниеПериода = УчетСтраховыхВзносов.ОкончаниеОтчетногоПериодаПерсУчета(ОтчетныйПериод);
	
	УчетСтраховыхВзносов.СформироватьТаблицуВТФизическиеЛицаРаботавшиеВОрганизации(Запрос.МенеджерВременныхТаблиц, Организация, НачалоПериода, ОкончаниеПериода);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	СотрудникиДокумента.НомерСтроки,
	               |	СотрудникиДокумента.Сотрудник КАК Сотрудник,
	               |	СотрудникиДокумента.Фамилия,
	               |	СотрудникиДокумента.Имя,
	               |	СотрудникиДокумента.Сотрудник.Наименование КАК СотрудникНаименование,
	               |	СотрудникиДокумента.АдресДляИнформирования,
	               |	СотрудникиДокумента.СтраховойНомерПФР,
	               |	МИНИМУМ(ДублиСтрок.НомерСтроки) КАК КонфликтующаяСтрока,
	               |	ВЫБОР
	               |		КОГДА АктуальныеСотрудники.ФизическоеЛицо ЕСТЬ NULL 
	               |			ТОГДА ЛОЖЬ
	               |		ИНАЧЕ ИСТИНА
	               |	КОНЕЦ КАК СотрудникРаботаетВОрганизации,
	               |	МИНИМУМ(ДублиСтрокСтраховыеНомера.НомерСтроки) КАК КонфликтующаяСтрокаСтраховойНомер
	               |ПОМЕСТИТЬ ВТСотрудникиДокумента
	               |ИЗ
	               |	ВТСотрудники КАК СотрудникиДокумента
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТСотрудники КАК ДублиСтрок
	               |		ПО СотрудникиДокумента.НомерСтроки > ДублиСтрок.НомерСтроки
	               |			И СотрудникиДокумента.Сотрудник = ДублиСтрок.Сотрудник
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТФизическиеЛицаРаботавшиеВОрганизации КАК АктуальныеСотрудники
	               |		ПО СотрудникиДокумента.Сотрудник = АктуальныеСотрудники.ФизическоеЛицо
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТСотрудники КАК ДублиСтрокСтраховыеНомера
	               |		ПО СотрудникиДокумента.НомерСтроки > ДублиСтрокСтраховыеНомера.НомерСтроки
	               |			И СотрудникиДокумента.СтраховойНомерПФР = ДублиСтрокСтраховыеНомера.СтраховойНомерПФР
	               |			И СотрудникиДокумента.Сотрудник <> ДублиСтрокСтраховыеНомера.Сотрудник
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	СотрудникиДокумента.НомерСтроки,
	               |	СотрудникиДокумента.Сотрудник,
	               |	СотрудникиДокумента.Фамилия,
	               |	СотрудникиДокумента.Имя,
	               |	СотрудникиДокумента.Сотрудник.Наименование,
	               |	СотрудникиДокумента.АдресДляИнформирования,
	               |	СотрудникиДокумента.СтраховойНомерПФР,
	               |	ВЫБОР
	               |		КОГДА АктуальныеСотрудники.ФизическоеЛицо ЕСТЬ NULL 
	               |			ТОГДА ЛОЖЬ
	               |		ИНАЧЕ ИСТИНА
	               |	КОНЕЦ
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	Сотрудник
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ТаблицаЗаписиОСтаже.Сотрудник,
	               |	ТаблицаЗаписиОСтаже.НомерСтроки,
	               |	ТаблицаЗаписиОСтаже.ДатаНачалаПериода,
	               |	ТаблицаЗаписиОСтаже.ДатаОкончанияПериода
	               |ПОМЕСТИТЬ ВТЗаписиОСтаже
	               |ИЗ
	               |	&ТаблицаЗаписиОСтаже КАК ТаблицаЗаписиОСтаже
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТЗаписиОСтаже.НомерСтроки КАК НомерСтроки,
	               |	ВТЗаписиОСтаже.Сотрудник,
	               |	ВТЗаписиОСтаже.ДатаНачалаПериода,
	               |	ВТЗаписиОСтаже.ДатаОкончанияПериода,
	               |	ЗНАЧЕНИЕ(Справочник.ОсобыеУсловияТрудаПФР.ПустаяСсылка) КАК ОсобыеУсловияТруда,
	               |	ЗНАЧЕНИЕ(Справочник.СпискиПрофессийДолжностейЛьготногоПенсионногоОбеспечения.ПустаяСсылка) КАК КодПозицииСписка,
	               |	ЗНАЧЕНИЕ(Справочник.ОснованияИсчисляемогоСтраховогоСтажа.ПустаяСсылка) КАК ОснованиеИсчисляемогоСтажа,
	               |	0 КАК ПервыйПараметрИсчисляемогоСтажа,
	               |	0 КАК ВторойПараметрИсчисляемогоСтажа,
	               |	ЗНАЧЕНИЕ(Справочник.ПараметрыИсчисляемогоСтраховогоСтажа.ПустаяСсылка) КАК ТретийПараметрИсчисляемогоСтажа,
	               |	ЗНАЧЕНИЕ(Справочник.ОснованияДосрочногоНазначенияПенсии.ПустаяСсылка) КАК ОснованиеВыслугиЛет,
	               |	0 КАК ПервыйПараметрВыслугиЛет,
	               |	0 КАК ВторойПараметрВыслугиЛет,
	               |	0 КАК ТретийПараметрВыслугиЛет,
	               |	ЗНАЧЕНИЕ(Справочник.ТерриториальныеУсловияПФР.ПустаяССылка) КАК ТерриториальныеУсловия,
	               |	0 КАК ПараметрТерриториальныхУсловий,
	               |	ЛОЖЬ КАК ФиксСтаж
	               |ПОМЕСТИТЬ ВТТаблицаСтажа
	               |ИЗ
	               |	ВТЗаписиОСтаже КАК ВТЗаписиОСтаже
	               |
	               |ИНДЕКСИРОВАТЬ ПО
	               |	ВТЗаписиОСтаже.Сотрудник
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ТаблицаСтажа.НомерСтроки КАК НомерСтрокиСтаж,
	               |	СотрудникиДокумента.НомерСтроки КАК НомерСтрокиСотрудник,
	               |	СотрудникиДокумента.Сотрудник КАК Сотрудник,
	               |	СотрудникиДокумента.СотрудникНаименование,
	               |	СотрудникиДокумента.АдресДляИнформирования,
	               |	СотрудникиДокумента.СтраховойНомерПФР,
	               |	СотрудникиДокумента.СотрудникРаботаетВОрганизации,
	               |	СотрудникиДокумента.КонфликтующаяСтрока,
	               |	СотрудникиДокумента.Фамилия,
	               |	СотрудникиДокумента.Имя,
	               |	ТаблицаСтажа.ДатаНачалаПериода,
	               |	ТаблицаСтажа.ДатаОкончанияПериода,
	               |	СотрудникиДокумента.КонфликтующаяСтрокаСтраховойНомер
	               |ИЗ
	               |	ВТСотрудникиДокумента КАК СотрудникиДокумента
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТТаблицаСтажа КАК ТаблицаСтажа
	               |		ПО СотрудникиДокумента.Сотрудник = ТаблицаСтажа.Сотрудник
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерСтрокиСотрудник,
	               |	НомерСтрокиСтаж";
	
	Возврат Запрос.Выполнить();
  
КонецФункции	

Процедура ПроверкаЗаполненияДокумента(ПроверяемыеРеквизиты, НеПроверяемыеРеквизиты, Отказ)Экспорт 
	
	ОкончаниеПериода = УчетСтраховыхВзносов.ОкончаниеОтчетногоПериодаПерсУчета(?(ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ, ОтчетныйПериод, КорректируемыйПериод));
	ДанныеОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, "Наименование, КодПоОКПО"); 
	
	ВыборкаЗаписиОСтаже = СформироватьЗапросПоСтажуДляПроверкиЗаполнения().Выбрать();
			
	Если ЗаписиОСтаже.Количество() > 200 Тогда
		ТекстОшибки = Нстр("ru = 'В документе должно быть не более 200 сотрудников !'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект,,,Отказ);
	КонецЕсли;
	
	Пока ВыборкаЗаписиОСтаже.СледующийПоЗначениюПоля("НомерСтрокиСотрудник") Цикл
		
		Если ЗначениеЗаполнено(ВыборкаЗаписиОСтаже.Сотрудник) Тогда 
			Если ВыборкаЗаписиОСтаже.КонфликтующаяСтрока <> Null Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Bнформация о сотруднике %2 была введена в документе ранее!'"), ВыборкаЗаписиОСтаже.НомерСтрокиСотрудник, ВыборкаЗаписиОСтаже.СотрудникНаименование);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(ВыборкаЗаписиОСтаже.НомерСтрокиСотрудник - 1, "ЧН=0; ЧГ=0") + "].Сотрудник",,Отказ);
			ИначеЕсли ВыборкаЗаписиОСтаже.КонфликтующаяСтрокаСтраховойНомер <> Null Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сотрудник %2: информация о сотруднике с таким же страховым номером была введена в документе ранее!'"), ВыборкаЗаписиОСтаже.НомерСтрокиСотрудник, ВыборкаЗаписиОСтаже.СотрудникНаименование);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(ВыборкаЗаписиОСтаже.НомерСтрокиСотрудник - 1, "ЧН=0; ЧГ=0") + "].Сотрудник",,Отказ);	
			КонецЕсли;
			
			ТекущаяОсновнаяЗапись = Новый Структура("Сотрудник, ДатаНачалаПериода, ДатаОкончанияПериода, ОсобыеУсловияТруда, ОснованиеВыслугиЛет, ТерриториальныеУсловия, ОснованиеИсчисляемогоСтажа, ОснованиеВыслугиЛетКод, НомерОсновнойЗаписи, НомерДополнительнойЗаписи");
			СписокТерриториальныеУсловияЗаписи = Новый СписокЗначений;
			СписокУсловияТрудаЗаписи = Новый СписокЗначений;
			СписокВыслугаЛетЗаписи = Новый СписокЗначений;
			
			ПредыдущийНомерОсновнойЗаписи = 0;
			ПредыдущийНомерДополнительнойЗаписи = 0;
			
			НомерСтроки = 0;
			
			Если ЗначениеЗаполнено(ВыборкаЗаписиОСтаже.НомерСтрокиСтаж) Тогда

				Пока ВыборкаЗаписиОСтаже.СледующийПоЗначениюПоля("НомерСтрокиСтаж") Цикл
					
					НомерСтроки = НомерСтроки + 1;
					
					// ПРОВЕРКА КОРРЕКТНОГО ЗАПОЛНЕНИЯ ДАТ НАЧАЛА И ОКОНЧАНИЯ ПЕРИОДА
									
					//Проверка заполненния реквзитов "ДатаНачалаПериода" и "ДатаОкончанияПериода" 
					Если ЗначениеЗаполнено(ВыборкаЗаписиОСтаже.ДатаНачалаПериода) И ЗначениеЗаполнено(ВыборкаЗаписиОСтаже.ДатаОкончанияПериода) Тогда
									
						//Дата начала периода не должна быть ранее начала периода
						Если ВыборкаЗаписиОСтаже.ДатаНачалаПериода < ?(ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ, ОтчетныйПериод, КорректируемыйПериод) Тогда
							ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сотрудника %2: дата начала периода должна быть не ранее начала периода!'"), НомерСтроки, ВыборкаЗаписиОСтаже.СотрудникНаименование);     
							ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(ВыборкаЗаписиОСтаже.НомерСтрокиСотрудник - 1, "ЧН=0; ЧГ=0") + "].ПериодыСтажаСтрока",,Отказ);

						КонецЕсли;	 
						
						//Дата окончания периода не должна быть позднее окончания периода
						Если ВыборкаЗаписиОСтаже.ДатаОкончанияПериода > ОкончаниеПериода Тогда
							ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сотрудник %2: дата окончания периода должна быть не позднее окончания периода!'"), НомерСтроки, ВыборкаЗаписиОСтаже.СотрудникНаименование);     
							ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(ВыборкаЗаписиОСтаже.НомерСтрокиСотрудник - 1, "ЧН=0; ЧГ=0") + "].ПериодыСтажаСтрока",,Отказ);
						КонецЕсли;	 
						
						// Начало периода не должно быть позже окончания периода 
						Если ВыборкаЗаписиОСтаже.ДатаНачалаПериода > ВыборкаЗаписиОСтаже.ДатаОкончанияПериода Тогда
							ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сотрудника %2: дата начала периода не должна превышать дату окончания периода!'"), НомерСтроки, ВыборкаЗаписиОСтаже.СотрудникНаименование);     
							ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(ВыборкаЗаписиОСтаже.НомерСтрокиСотрудник - 1, "ЧН=0; ЧГ=0") + "].ПериодыСтажаСтрока",,Отказ);
						КонецЕсли;
						
					КонецЕсли;	
					
				КонецЦикла;
			КонецЕсли;	
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

Функция ПолучитьДанныеДляПроведения()
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеестрСЗВ_6_2Сотрудники.НачисленоСтраховая,
	|	РеестрСЗВ_6_2Сотрудники.УплаченоСтраховая,
	|	РеестрСЗВ_6_2Сотрудники.НачисленоНакопительная,
	|	РеестрСЗВ_6_2Сотрудники.УплаченоНакопительная,
	|	РеестрСЗВ_6_2Сотрудники.Сотрудник КАК ФизическоеЛицо,
	|	РеестрСЗВ_6_2Сотрудники.Ссылка.КатегорияЗастрахованныхЛиц
	|ИЗ
	|	Документ.РеестрСЗВ_6_2.Сотрудники КАК РеестрСЗВ_6_2Сотрудники
	|ГДЕ
	|	РеестрСЗВ_6_2Сотрудники.Ссылка = &Ссылка";
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции	

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ДанныеДляПроведения = ПолучитьДанныеДляПроведения();
	
	ПериодРасчетов = ?(ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.ИСХОДНАЯ, ОтчетныйПериод, КорректируемыйПериод);
	
КонецПроцедуры

#КонецЕсли
