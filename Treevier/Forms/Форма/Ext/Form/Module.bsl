﻿
&НаСервере
Процедура СформироватьНаСервере()
	
	ТекущийЗум			= 100;
	Модули 			 	= НайтиФайлы(ПутьККонфигурации, "*.bsl", Истина);
	НазванияОбъектов 	= ВернутьНазванияОбъектов();
	НазванияГрупп	 	= ВернутьНомераПозицийГрупп();
	ЭлементыДК			= ДеревоКонфиуграции.ПолучитьЭлементы();
	КартинкиГрупп		= ВернутьКартинкиГрупп();
	
	Для Н = 0 По НазванияГрупп.Количество() Цикл 
		Для Каждого НазваниеГруппы Из НазванияГрупп Цикл
			
			Если НазваниеГруппы.Значение = Н Тогда
				НоваяГруппа = ЭлементыДК.Добавить();
				НоваяГруппа.Имя 		= НазваниеГруппы.Ключ;
				НоваяГруппа.Картинка    = КартинкиГрупп.Получить(НазваниеГруппы.Ключ);
			КонецЕсли;
			
		КонецЦикла;                    
	КонецЦикла;
	                         
	Для Каждого Модуль Из Модули Цикл
		
		ИмяМодуля 			= СтрЗаменить(Модуль.ПолноеИмя, ПутьККонфигурации, "");
		МассивИмени 		= СтрРазделить(ИмяМодуля, "\", Ложь);
		СформированноеИмя 	= "";
		ИмяОбращения 		= "";             
		
		Для Каждого ЭлементИмени Из МассивИмени Цикл
			
			ТекущийЭлементИмени	= ЭлементИмени;
			СтрокаЗамены 		= НазванияОбъектов.Получить(ТекущийЭлементИмени);
			
			ПопыткаИмяГруппы	= НазванияГрупп.Получить(СтрокаЗамены);
			ИмяГруппы			= ?(ПопыткаИмяГруппы = Неопределено, ИмяГруппы, СтрокаЗамены);
			
			Если СтрокаЗамены = "Общие модули" Тогда
				СтрокаЗамены = "";
			КонецЕсли;
			
			Если СтрокаЗамены <> Неопределено Тогда
				ТекущийЭлементИмени = СтрокаЗамены;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ТекущийЭлементИмени) Тогда
				
				Если ЗначениеЗаполнено(СформированноеИмя) Тогда
					СформированноеИмя = СформированноеИмя + ".";	
				КонецЕсли;
				
				СформированноеИмя = СформированноеИмя + ТекущийЭлементИмени;
			КонецЕсли;
			
		КонецЦикла;
			
		НоваяПозиция 			= ДеревоКонфиуграции.ПолучитьЭлементы()[НазванияГрупп.Получить(ИмяГруппы)].ПолучитьЭлементы().Добавить();
		НоваяПозиция.Имя 		= СформированноеИмя;
		НоваяПозиция.Уровень	= 2;
		ИмяОбращения			= СформированноеИмя + ".";
		
		ТекстМодуля = Новый ЧтениеТекста(Модуль.ПолноеИмя);
		
		ТекущаяСтрока 				= ТекстМодуля.ПрочитатьСтроку();
		НоваяПозиция.ТекстМодуля 	= ТекущаяСтрока;
		ЗаписьТекстаМетода			= Ложь;
		
		Пока ТекущаяСтрока <> Неопределено Цикл
			
			ТекущаяСтрока 				= ТекстМодуля.ПрочитатьСтроку();
			НоваяПозиция.ТекстМодуля 	= НоваяПозиция.ТекстМодуля + Символы.ПС + ТекущаяСтрока;
			
			Если СтрНайти(ТекущаяСтрока, "Функция") > 0 Или СтрНайти(ТекущаяСтрока, "Процедура") > 0 Тогда
				
				ЗаписьТекстаМетода 	= Истина;
				ИмяМетода			= СтрЗаменить(ТекущаяСтрока	, "Процедура"	, "");
				ИмяМетода			= СтрЗаменить(ИмяМетода		, "Функция"		, "");
				ИмяМетода			= Лев(ИмяМетода, СтрНайти(ИмяМетода, "(") - 1);
				ИмяМетода			= СокрЛП(ИмяМетода);
				
				НовыйМетод 				= НоваяПозиция.ПолучитьЭлементы().Добавить();
				НовыйМетод.Имя 			= ИмяМетода;
				НовыйМетод.ТекстМодуля 	= ТекущаяСтрока;
				НовыйМетод.Уровень		= 3;
				
				НовоеОбращение 					= СписокИменОбращений.Добавить();
				НовоеОбращение.Значение 		= ИмяОбращения + ИмяМетода;
				НовоеОбращение.Идентификатор 	= НовыйМетод.ПолучитьИдентификатор();
				
			ИначеЕсли СтрНайти(ТекущаяСтрока, "КонецФункции") > 0 Или СтрНайти(ТекущаяСтрока, "КонецПроцедуры") > 0 Тогда
				
				ЗаписьТекстаМетода 	= Ложь;
				НовыйМетод.ТекстМодуля 	= НовыйМетод.ТекстМодуля + Символы.ПС + ТекущаяСтрока;
				
			ИначеЕсли ЗаписьТекстаМетода Тогда
				
				НовыйМетод.ТекстМодуля 	= НовыйМетод.ТекстМодуля + Символы.ПС + ТекущаяСтрока;
			КонецЕсли;    
			
		КонецЦикла;
		
		
	КонецЦикла;
	
	Для Каждого ЗагруженнаяГруппа Из ДеревоКонфиуграции.ПолучитьЭлементы() Цикл
		Для Каждого ЗагруженныйМодуль Из ЗагруженнаяГруппа.ПолучитьЭлементы() Цикл
		
		МетодыМодуля = ЗагруженныйМодуль.ПолучитьЭлементы();
		
		Для Каждого МетодМодуля Из МетодыМодуля Цикл
			
			ТекстМетода = МетодМодуля.ТекстМодуля;
			
			Для Каждого ВозможноеОбращение Из СписокИменОбращений Цикл
				Если СтрНайти(ТекстМетода, ВозможноеОбращение.Значение) > 0 Тогда
					
					НовоеОбращение = МетодМодуля.ПолучитьЭлементы().Добавить();
					НовоеОбращение.Имя = СтрЗаменить(ВозможноеОбращение.Значение, "(", "");
					НовоеОбращение.ИдентификаторВызываемого = ВозможноеОбращение.Идентификатор;
					
				КонецЕсли;
			КонецЦикла;
			
			Для Каждого МетодМодуляВызываемый Из МетодыМодуля Цикл
				Если СтрНайти(ТекстМетода, МетодМодуляВызываемый.Имя + "(") > 0 И Не МетодМодуляВызываемый.Имя = МетодМодуля.Имя Тогда
					
					НовоеОбращение = МетодМодуля.ПолучитьЭлементы().Добавить();
					НовоеОбращение.Имя = МетодМодуляВызываемый.Имя;
					НовоеОбращение.ИдентификаторВызываемого = МетодМодуляВызываемый.ПолучитьИдентификатор();
					
				КонецЕсли;	
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	КонецЦикла;
		
КонецПроцедуры	
	
&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПутьККонфигурации = "C:\Users\Администратор\Desktop\Conf";
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВернутьНазванияОбъектов()
	
	СоответствиеНазваний = Новый Соответствие;
	СоответствиеНазваний.Вставить("AccumulationRegisters"	, "Регистры накопления"); 
	СоответствиеНазваний.Вставить("Catalogs"				, "Справочники"); 
	СоответствиеНазваний.Вставить("CommonModules"			, "Общие модули");
	СоответствиеНазваний.Вставить("CommonForms"				, "Общие формы");
	СоответствиеНазваний.Вставить("DataProcessors"			, "Обработки"); 
	СоответствиеНазваний.Вставить("Documents"				, "Документы"); 
	СоответствиеНазваний.Вставить("HTTPServices"			, "HTTP-сервисы"); 
	СоответствиеНазваний.Вставить("InformationRegisters"	, "Регистры сведений");
	СоответствиеНазваний.Вставить("Reports"					, "Отчеты");
	СоответствиеНазваний.Вставить("Forms"					, "Формы");
	СоответствиеНазваний.Вставить("Form"					, "");
	СоответствиеНазваний.Вставить("Ext"						, "");
	СоответствиеНазваний.Вставить("Module.bsl"				, "");
	СоответствиеНазваний.Вставить("ManagerModule.bsl"		, "МодульМенеджера");
	СоответствиеНазваний.Вставить("ObjectModule.bsl"		, "МодульОбъекта");

	
	Возврат СоответствиеНазваний;

КонецФункции

&НаСервереБезКонтекста
Функция ВернутьНомераПозицийГрупп()
	
	СоответствиеНазваний = Новый Соответствие;
	СоответствиеНазваний.Вставить("Общие модули"			, 0); 
	СоответствиеНазваний.Вставить("Общие формы"				, 1); 
	СоответствиеНазваний.Вставить("Веб-сервисы"				, 2); 
	СоответствиеНазваний.Вставить("HTTP-сервисы"			, 3); 
	СоответствиеНазваний.Вставить("Справочники"				, 4); 
	СоответствиеНазваний.Вставить("Документы"				, 5); 
	СоответствиеНазваний.Вставить("Отчеты"					, 6); 
	СоответствиеНазваний.Вставить("Обработки"				, 7); 
	СоответствиеНазваний.Вставить("Регистры сведений"		, 8); 
	СоответствиеНазваний.Вставить("Регистры накопления"		, 9);
	СоответствиеНазваний.Вставить("Регистры бухгалтерии"	, 10);
	СоответствиеНазваний.Вставить("Регистры расчета"		, 11);

	Возврат СоответствиеНазваний;
	
КонецФункции


&НаСервереБезКонтекста
Функция ВернутьКартинкиГрупп()
	
	СоответствиеНазваний = Новый Соответствие;
	СоответствиеНазваний.Вставить("Общие модули"			, БиблиотекаКартинок.ВнешнийИсточникДанныхТаблица); 
	СоответствиеНазваний.Вставить("Общие формы"				, БиблиотекаКартинок.Форма); 
	СоответствиеНазваний.Вставить("Веб-сервисы"				, БиблиотекаКартинок.ГеографическаяСхема); 
	СоответствиеНазваний.Вставить("HTTP-сервисы"			, БиблиотекаКартинок.ГеографическаяСхема); 
	СоответствиеНазваний.Вставить("Справочники"				, БиблиотекаКартинок.Справочник); 
	СоответствиеНазваний.Вставить("Документы"				, БиблиотекаКартинок.Документ); 
	СоответствиеНазваний.Вставить("Отчеты"					, БиблиотекаКартинок.Отчет); 
	СоответствиеНазваний.Вставить("Обработки"				, БиблиотекаКартинок.Обработка); 
	СоответствиеНазваний.Вставить("Регистры сведений"		, БиблиотекаКартинок.РегистрСведений); 
	СоответствиеНазваний.Вставить("Регистры накопления"		, БиблиотекаКартинок.РегистрНакопления);
	СоответствиеНазваний.Вставить("Регистры бухгалтерии"	, БиблиотекаКартинок.РегистрБухгалтерии);
	СоответствиеНазваний.Вставить("Регистры расчета"		, БиблиотекаКартинок.РегистрРасчета);

	Возврат СоответствиеНазваний;
	
КонецФункции



&НаКлиенте
Процедура Трассировка(Команда)
	
	ДеревоТрассировки.ПолучитьЭлементы().Очистить();
	ДанныеГрафа	= "";
	
	ТД 					= Элементы.ДеревоКонфиуграции.ТекущиеДанные;
	СтруктураТекущего 	= Новый Структура;
	
	СтруктураТекущего.Вставить("Уровень"		, ТД.Уровень);
	СтруктураТекущего.Вставить("Имя"			, ТД.Имя);
	СтруктураТекущего.Вставить("Идентификатор"  , ТД.ПолучитьИдентификатор());
	ТрассировкаНаСервере(СтруктураТекущего);
	
	Элементы.Группа3.ТекущаяСтраница = Элементы.СтраницаТрассировка;
	
КонецПроцедуры


&НаСервере
Процедура ТрассировкаНаСервере(ТД)
	
	Если Не ТД.Уровень = 3 Тогда
		Возврат;
	КонецЕсли;
	
	НоваяПозиция = ДеревоТрассировки.ПолучитьЭлементы().Добавить();
	НоваяПозиция.Метод 			= ТД.Имя;
	НоваяПозиция.Идентификатор 	= ТД.Идентификатор;
	НоваяПозиция.Уровень 		= 2;
	НоваяПозиция.ID				= НоваяПозиция.ПолучитьИдентификатор();
	НоваяПозиция.Показывать		= Истина;
	
	ВыполнитьРазбор(НоваяПозиция, ДеревоКонфиуграции.НайтиПоИдентификатору(ТД.Идентификатор), 3);
	
	ОбновитьКартуТрассировки();

КонецПроцедуры

&НаСервере
Процедура ВыполнитьРазбор(СтрокаДереваПриемник, СтрокаДереваИсточник, Уровень) 
	
	ПоказателиУровня 	= СтрокаДереваИсточник.ПолучитьЭлементы();
	
	//НачалоЭлементаГрафа = "[""" + СтрокаДереваИсточник.Имя + """, """;
	//НачалоЭлементаГрафа = "[""" + Строка(Новый УникальныйИдентификатор) + """, """;

	
	Для Каждого ПоказательУровня Из ПоказателиУровня Цикл
		
		//ДанныеГрафа = ДанныеГрафа + НачалоЭлементаГрафа + ПоказательУровня.Имя + """]," + Символы.ПС; 
		//ДанныеГрафа = ДанныеГрафа + НачалоЭлементаГрафа +  Строка(Новый УникальныйИдентификатор) + """]," + Символы.ПС; 
		
		ДочернийПоказатель 	= СтрокаДереваПриемник.ПолучитьЭлементы().Добавить();
		ДанныеИсточник		= ДеревоКонфиуграции.НайтиПоИдентификатору(ПоказательУровня.ИдентификаторВызываемого);
		
		ДочернийПоказатель.Метод 			= ДанныеИсточник.Имя;
		ДочернийПоказатель.Идентификатор 	= ПоказательУровня.ИдентификаторВызываемого;
		ДочернийПоказатель.Уровень			= Уровень;
		ДочернийПоказатель.ID				= ДочернийПоказатель.ПолучитьИдентификатор();
		ДочернийПоказатель.Показывать		= Истина;
		
		
		Если Не ДанныеИсточник.ПолучитьЭлементы().Количество() = 0 Тогда
			ПередаваемыйУровень = Уровень + 1;
			ВыполнитьРазбор(ДочернийПоказатель, ДанныеИсточник, ПередаваемыйУровень);
		КонецЕсли;
		
	КонецЦикла;
	
	
		
КонецПроцедуры

&НаСервере
Процедура ОбходДереваДетально(ПереданноеДер)

	Если Не ЗначениеЗаполнено(ДанныеГрафа) Тогда
		ДанныеГрафа = "[";
		ТекущийУровеньТрассировки = 0;
	КонецЕсли;
	
	Для Каждого СтрПолученногоДерева Из ПереданноеДер.ПолучитьЭлементы() Цикл
		
		Если Не СтрПолученногоДерева.Показывать Тогда
			Продолжить;
		КонецЕсли;
		
		
		Уровень 			= СтрПолученногоДерева.Уровень;                                            
		Метод				= СтрПолученногоДерева.Метод + " (" + Строка(СтрПолученногоДерева.ID) + ")";
			
		Если ТекущийУровеньТрассировки < Уровень Тогда
			
			ДанныеГрафа = ДанныеГрафа + ?(ДанныеГрафа = "[", "", ",") + """" + Метод + """";
			ТекущийУровеньТрассировки = Уровень;
			
		Иначе
			
			  ДанныеГрафа = ДанныеГрафа + "]," + Символы.ПС + "[";
			  РодительскийМетод  = СтрПолученногоДерева.ПолучитьРодителя().Метод + " (" + Строка(СтрПолученногоДерева.ПолучитьРодителя().ID) + ")";
			  ДанныеГрафа = ДанныеГрафа + """" + РодительскийМетод + """";
			  ДанныеГрафа = ДанныеГрафа + "," + """" + Метод + """";

		КонецЕсли;
		
		ЕстьАктивные = Ложь;
		
		НовыйДочерние = СтрПолученногоДерева.ПолучитьЭлементы();
		Для Каждого НоваяДочерняя Из НовыйДочерние Цикл		
			Если НоваяДочерняя.Показывать Тогда
				ЕстьАктивные = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		
		Если ЕстьАктивные Тогда
			
			ОбходДереваДетально(СтрПолученногоДерева);
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры


&НаКлиенте
Процедура ОбновитьКарту(Команда)

	ОбновитьКартуТрассировки();
КонецПроцедуры

&НаСервере
Процедура ОбновитьКартуТрассировки()
	
	ТекущийУровеньТрассировки 	= 0;
	ДанныеГрафа					= "";
	
	Обработка =  РеквизитФормыВЗначение("Объект");
	Макет = Обработка.ПолучитьМакет("Граф").ПолучитьТекст(); 
	
	ОбходДереваДетально(ДеревоТрассировки);	
	КартаТрассивровки = СтрЗаменить(Макет, "@Данные", ДанныеГрафа + "]");

КонецПроцедуры


&НаКлиенте
Процедура ПрибавитьЗум(Команда)
	ТекущийЗум = ТекущийЗум + 10;
	Элементы.КартаТрассивровки.Документ.body.firstElementChild.style.zoom = Строка(ТекущийЗум) + "%";
КонецПроцедуры


&НаКлиенте
Процедура УбавитьЗум(Команда)
	ТекущийЗум = ТекущийЗум - 10;
	Элементы.КартаТрассивровки.Документ.body.firstElementChild.style.zoom = Строка(ТекущийЗум) + "%";
КонецПроцедуры

